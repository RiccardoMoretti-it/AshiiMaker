import java.util.concurrent.*;
import java.io.FileWriter;
import java.awt.*;
import java.awt.event.*;
import java.awt.datatransfer.*;
import javax.swing.*;
import java.io.*;

public class Ascii {
  char [][]matrix;//matrice che definisce i caratteri a schermo
  PFont font;
  float textHeight, textWidth;
  boolean threading=false;
  //tendina
  PVector position=new PVector(0, 0);
  float size=(int)(displayWidth/50);
  boolean press=false;
  PGraphics asciiImage;

  //costruttore
  Ascii(PFont font, float textHeight) {
    updateVideo();
    updateFont(font, textHeight);
  }
  //al cambio di fontSize vengono aggiornati i parametri
  void updateVideo() {
    //setup tendina
    position=new PVector(width/2, height/2);
    //setup ascii immagine
    asciiImage= createGraphics(width, height);
    if (font!=null)
      initializeMatrix();
  }

  //al cambio di immagine vengono aggiornati i parametri
  void updateFont(PFont font, float textHeight) {
    this.font=font;
    this.textHeight=textHeight;
    asciiImage.beginDraw();
    asciiImage.textFont(font, textHeight);  
    this.textWidth=asciiImage.textWidth("a");
    asciiImage.endDraw();
    initializeMatrix();
    //tendina
  }
  //trasforma in bianco e nero un'immagine prendendo i valori di Red Blue Green
  //sommandoli e dividendoli per tre ottenendo la scala di grigio corrispondente
  PImage blackWhite(PImage image) {
    double redPart = 0.299;
    double greenPart = 0.587;
    double bluePart = 0.114;
    image.loadPixels();
    for (int i=0; i<image.pixels.length; i++)image.pixels[i]= color((int)(red(image.pixels[i])*redPart+green(image.pixels[i])*greenPart+blue(image.pixels[i])*bluePart));
    return image;
  }

  int threadNumber=1;
  CountDownLatch counter;
  void threading() {
    if (width!=asciiImage.width)updateVideo();
    counter = new CountDownLatch(threadNumber);

    for (int i=0; i<threadNumber; i++) {
      threading=true;
      int startX=floor(width*i/threadNumber);
    
      PImage screen=blackWhite(get(0, 0, width, height));
      screen.loadPixels();
      int grey;
      int x=0, y;
      for (int currentY=0; currentY<matrix[0].length; currentY++)
        for (int currentX=0; currentX<matrix.length; currentX++) {
          grey=0;
          float currentHeight=currentY*textHeight;
          float currentWidth=currentX*textWidth;
          for (y=0; y<textHeight && y+currentHeight<height; y++)
            for (x=0; x<textWidth && x+currentWidth<width; x++) {
              grey+=brightness(screen.pixels[(floor(currentWidth+x)+width*floor(currentHeight+y))]);
            }
          try {
          grey/=x*y;
            matrix[currentX+floor(startX/textWidth)][currentY]=greyScale[(int)map(floor(grey), 0, 255, 0, greyScale.length-1)];
          }
          catch(Exception e) {
            println();
          }
        }
      counter.countDown();
      threading=false;
    }
    //prosegue solo se il timer ha concluso
    try { 
      counter.await();
    }
    catch(InterruptedException  e) { 
      print(e);
    }
  }
  void initializeMatrix() {
    matrix=new char[ceil(width*1.0/textWidth)][ceil(height*1.0/textHeight)];
  }
  void showMatrix() {
    asciiImage.beginDraw();
    asciiImage.background(0);
    for (int y=0; y<matrix[0].length; y++)
      for (int x=0; x<matrix.length; x++)
        asciiImage.text(matrix[x][y], textWidth*x, textHeight*2/3+textHeight*y);

    asciiImage.endDraw();
    checkCurtain();

    //disegna solo la porzione scelta con lo slider
    PImage a=asciiImage.get((int)(position.x), 0, (int)(width-position.x), (height));
    image(a, position.x, 0);
    strokeWeight(2);
    line(position.x, 0, position.x, height);
    ellipse(position.x, position.y, size, size);
  }

  void checkCurtain() {
    if (press)
      position=new PVector(constrain(mouseX, 0, width), constrain(mouseY, 0, height));
  }

  void mousePressed() {
    if (mouseButton==37)press=true;
    if (mouseButton==39){
  }
  }
  void mouseReleased() {
    if (mouseButton==37)press=false;
  }
  void keyPressed() { 
    if (key=='-') {
      textHeight--;
      updateFont(font, textHeight);
    }
    if (key=='+') {
      textHeight++;
      updateFont(font, textHeight);
    }
    //Spazio: salva i dati su file
    if (keyCode==32) {
      String a="";
      for (int y=0; y<matrix[0].length; y++) {
        for (int x=0; x<matrix.length; x++)
          a+=String.valueOf(matrix[x][y]);
        a+="\n";
      }
      try {
        OutputStream output=createOutput("position.txt");
        output.write(a.getBytes());  
        output.flush();  
        output.close(); 
        StringSelection data = new StringSelection(a);
        Clipboard clipboard = 
          Toolkit.getDefaultToolkit().getSystemClipboard();
        clipboard.setContents(data, data);
      }
      catch(Exception e) {
      }
    }
  }
}
public class Shape {
  color c;
  boolean[][] block=new boolean[4][4];
  int X, Y;
  Shape() {
    X=4;
    Y=0;
    for (int y=0; y<4; y++)
      for (int x=0; x<4; x++)
        block[x][y]=false;
  }
  int getX() {
    return X;
  }
  int getY() {
    return Y;
  }
  boolean[][] getBlock() {
    return block;
  }
  color getColor() {
    return c;
  }

  int Routa() {
    boolean[][] newBlock=new boolean[4][4];
    for (int y=0; y<4; y++)
      for (int x=0; x<4; x++)
        newBlock[3-y][x]=block[3-x][3-y];
    block=newBlock;
    //porta il pezzo a sinistra ed in alto se ci sono spazi vuoti
    boolean uscita=true;
    int appoggio=0;
   
    for (int y=0; y<4&&uscita; y++)
      for (int x=0; x<4&&uscita; x++){
        if (y==0){if(block[x][y])uscita=false;}
        else if(block[x][y]&&appoggio==0)
        appoggio=y;
        if (y>0&&block[x][y]&&appoggio!=0){
          block[x][y-appoggio]=block[x][y];
          block[x][y]=false;
        }
      }
      //restituisce la coordinata (X) più esterna per evitare di ruotare male un pezzo dentro le colonne
      for (int x=3; x>=0; x--)
         for (int y=0; y<4; y++)
           if(block[x][y])return 3-x;
           //else che serve per fare felice il compilatore
      return 99;

}
  void Sposta(String s) {
    switch(s) {
    case "sinistra":
      if (X>0)X--;
      break;
    case "destra":
      int x;
      boolean uscita=false;
      for (x=3; x>0&&!uscita; x--){
        for (int y=0; y<4&&!uscita; y++)
          if (block[x][y])
            uscita=true;
        if(uscita)break;}
      if (x+X<9)X++;
      break;
    case "giu":
      Y++;
      break;
    }
  }
}



public class Campo {
  color[][] campo=new color[10][24];
  Campo() {
    for (int x=0; x<10; x++)
      for (int y=0; y<24; y++) {
        campo[x][y]=0;
      }
  }
  color[][] getCampo() {
    return campo;
  }
  void setBlocco(int x, int y, color c) {
    campo[x][y]=c;
  }
}
//Da qui in poi ci sono solo 
//sottoclassi di Shape che 
//dichiarano la propria forma

class TShape extends Shape {
  TShape() {
    for (int i=0; i<3; i++)block[i][0]=true;
    block[1][1]=true;
    c=color(151, 90, 209);
  }
}
class IShape extends Shape {
  IShape() {
    for (int x=0; x<4; x++)
      block[x][0]=true;
    c=color(20, 170, 255);
  }
}
class OShape extends Shape {
  OShape() {
    for (int x=0; x<2; x++)
      for (int y=0; y<2; y++)
        block[x][y]=true;
    c=color(255, 207, 18);
  }
}
class SShape extends Shape {
  SShape() {
    for (int y=0; y<2; y++)
      for (int x=0; x<2; x++)
        if (y!=0)block[x][y]=true;
        else block[x+1][y]=true;
    c=color(255,32, 0);
  }
}
class ZShape extends Shape {
  ZShape() {
    for (int y=0; y<2; y++)
      for (int x=0; x<2; x++)
        if (y==0)block[x][y]=true;
        else block[x+1][y]=true;
    c=color(6, 201, 65);
  }
}
class LShape extends Shape {
  LShape() {
    for (int i=0; i<3; i++)
      block[i][0]=true;
    block[0][1]=true;
    c=color(255, 136, 0);
  }
}
class JShape extends Shape {
  JShape() {
    for (int i=0; i<3; i++)
      block[i][0]=true;
    block[2][1]=true;
    c=color(255, 0, 170);
  }
}

char[] greyScale="        ''''''''..................------------\"\"\"\"\"\"\"\"\"\"\"^^^^^_________LLLLLLLLLTTTT+++++IIIII1111EEEEEYYYYZZZZZ££££nnnnnooooPPPPPAAAAARRRRDDDDDbbbbOOOOOBBBB$$$$$$$88888880000000&&&&&&&&&&&&&&&&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@".toCharArray() ;
int fontSize=40;
//slider

boolean camera=false;
  
PImage image; //immagine o video (non relativo alla classe Ascii)
Ascii toAscii; 
