public class Ashii{

   PFont font;
   float textHeight, textWidth;
  //=11
    Ashii(PFont font,float textHeight){
    this.textHeight=textHeight;
    textFont(font);   
    this.textWidth=textWidth("a");
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
int startX,Width,startY,Height;
boolean canThread=true;
void threading(){
  for(int y=0;y<2; y++) {
    for(int x=0;x<2; x++) {
    while(!canThread);
    canThread=false;
    startX=x*width/2;
    startY=y*height/2;
    Width=width/2;
    Height=height/2;
    toAshii a=new toAshii();
    a.run();
    break;
    //while(!canThread);
  }
  break;
  }
}
class toAshii implements Runnable{
  @Override
  public void run (){
    println(width+" "+height);
    println(Width+" "+Height);
    PImage a=get();
    PImage screen= blackWhite(a);
    screen.loadPixels();
    int grey;
    canThread=true;  
    for (int currentY=0; currentY<screen.width; currentY++) {
      for (int currentX=0; currentX<screen.height; currentX++) {
        grey=0;
        int y=(int)(currentY*textHeight), x;
        do {
          x=(int)(currentX*textWidth);
          do {       
            grey+=   red(screen.pixels[x +screen.width*y]);
          } while (x++<currentX*textWidth+textWidth && x<screen.width);
        } while (y++<currentY*textHeight+textHeight && y<screen.height);
      grey/=((x-(int)(currentX*textWidth))*(y-(int)(currentY*textHeight)));
      matrix[currentX][currentY]=greyScale[(int)map(grey, 0, 255, 0, greyScale.length-1)];
    }
  }
  }
}

/*void toAshii() {
  PImage screen= blackWhite(get());
  screen.loadPixels();
  int grey;
  int sX=startX;
  int eX=endX;
  int sY=startY;
  int eY=endY;
  canThread=true;
  print("a");
  
  for (int currentY=sY; currentY<eY; currentY++) {
    for (int currentX=sX; currentX<eX; currentX++) {
      grey=0;
      int y=(int)(currentY*textHeight), x;
      do {
        x=(int)(currentX*textWidth);
        do {       
          grey+=   red(screen.pixels[x +screen.width*y]);
        } while (x++<currentX*textWidth+textWidth && x<screen.width);
      } while (y++<currentY*textHeight+textHeight && y<screen.height);
      grey/=((x-(int)(currentX*textWidth))*(y-(int)(currentY*textHeight)));
      matrix[currentX][currentY]=greyScale[(int)map(grey, 0, 255, 0, greyScale.length-1)];
    }
  }
  //showMatrix();
}
*/
void Matrix() {
  matrix=new char[ceil(width*1.0/textWidth)][ceil(height*1.0/textHeight)];
}
void showMatrix() {
  background(0);
  for (int y=0; y<matrix[0].length; y++) {
    for (int x=0; x<matrix.length; x++) {
      text(matrix[x][y], textWidth*x, textHeight/2+textHeight*y);
    }
  }
}
  
}
