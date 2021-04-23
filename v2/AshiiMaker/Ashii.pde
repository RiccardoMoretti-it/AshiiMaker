import java.util.concurrent.*;

public class Ascii {
  char [][]matrix;//matrice che definisce i caratteri a schermo
  PFont font;
  float textHeight, textWidth;

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
    if(font!=null)
    initializeMatrix();
  }
  
  //al cambio di immagine vengono aggiornati i parametri
  void updateFont(PFont font, float textHeight) {
    this.textHeight=textHeight;
    asciiImage.beginDraw();
    asciiImage.textFont(font);  
    textMode(MODEL);
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

  boolean canThread=true;
  int threadNumber=1;
  CountDownLatch counter;
  void threading() {
    if (width!=asciiImage.width)updateVideo();
    counter = new CountDownLatch(threadNumber);
    for(int y=0;y<matrix[0].length;y++)
    for(int x=0;x<matrix.length;x++)
    matrix[x][y]=0;
    
    for (int i=0; i<threadNumber; i++) {
      canThread=false;
      Thread a=new Thread(new toAshii(floor(width*i/threadNumber), floor(width*(i+1)/threadNumber)));
      a.start();
    }
    //prosegue solo se il timer ha concluso
    try { 
      counter.await();
    }
    catch(InterruptedException  e) { 
      print(e);
    }
  }

  class toAshii implements Runnable {
    int startX;
    int endX;
    toAshii(int startX, int endX) {
      this.startX=startX;
      this.endX=endX;
    }
    @Override
      public void run () {
      PImage screen=blackWhite(get(startX, 0, endX, height));
      canThread=true;
      screen.loadPixels();
      int grey;
      int x,y;
      for(int currentY=0;currentY<ceil(height/textHeight);currentY++)
        for(int currentX=0;currentX<(endX-startX)/textWidth;currentX++){
          grey=0;
          x=0;
          y=0;
          for(y=0;y<textHeight && y+currentY*textHeight<height;y++)
            for(x=0;x<textWidth && x+currentX*textWidth<endX;x++){
            grey+=brightness(screen.get(floor(currentX*textWidth+x),floor(currentY*textHeight+y)));
            }
         grey/=x*y;
         try{
           println(currentX+floor(startX/textWidth));
           println(currentX+" + "+"floor "+" "+startX+" "+" / "+textWidth);
         matrix[currentX+floor(startX/textWidth)][currentY]=greyScale[(int)map(floor(grey), 0, 255, 0, greyScale.length-1)];
         }
         catch(Exception e){
           println(); //<>//
         }
      }
      counter.countDown();
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
        asciiImage.text(matrix[x][y], textWidth*x, textHeight/2+textHeight*y);

    asciiImage.endDraw();
    checkCurtain();

    //disegna solo la porzione scelta con lo slider
    PImage a=asciiImage.get((int)(position.x), 0, (int)(width-position.x), (height));
    //tint(0, 153, 204);    ///RIMUOVI///
    image(a, position.x,0);
    //noTint();    ///RIMUOVI///
    //disegna la tendina
    strokeWeight(2);
    line(position.x, 0, position.x, height);
    ellipse(position.x, position.y, size, size);
  }

  void checkCurtain() {
    ///CAMBIARE (IMAGE.WIDTH ECC)///
    if (press)
      position=new PVector(constrain(mouseX, 0, width), constrain(mouseY, 0, height));
  }

  void mousePressed() {
    if (mouseButton==37)press=true;
    if (mouseButton==39)
      setImage();
  }
  void mouseReleased() {
    if (mouseButton==37)press=false;
  }
}
