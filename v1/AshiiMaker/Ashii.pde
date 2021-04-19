import java.util.concurrent.*;

public class Ashii {

  char [][]matrix;
  PFont font;
  float textHeight, textWidth;
  Ashii(PFont font, float textHeight) {
    this.textHeight=textHeight;
    textFont(font);   
    this.textWidth=textWidth("a");
    Matrix();
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
  int startX;
  boolean canThread=true;
  int threadNumber=2;
  CountDownLatch counter;
  void threading() {
    counter = new CountDownLatch(threadNumber);
    for (int i=0; i<threadNumber; i++) {
      canThread=false;
      Thread a=new Thread(new toAshii(floor(width*i/threadNumber),floor(width*(i+1)/threadNumber)));
      
      a.start();
    }
    //prosegue solo se il timer ha concluso
    try { counter.await(); }
    catch(InterruptedException  e) { print(e); }
    print();
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
      int x=0,y;
      if(startX>0)
      print();
      for (int currentY=0; currentY<ceil(height/textHeight); currentY++) 
        for (int currentX=0; currentX<ceil((endX-startX)/textWidth); currentX++) {
          grey=0;
          for(  y=0;y<textHeight;y++)
            for(  x=0;x<textWidth;x++)
            try{
              grey+=   brightness(screen.pixels[(int)(currentX*textWidth+x) +(int)(screen.width*(currentY*textHeight+y))]);
        }
          catch(Exception e){
          break;
        }
          
          grey/=((x+1-(int)(currentX*textWidth))*(y+1-(int)(currentY*textHeight)));
          matrix[currentX+floor(startX/textWidth)][currentY]=greyScale[(int)map(grey, 0, 255, 0, greyScale.length-1)];
      }
      counter.countDown();
    }
  }

  void Matrix() {
    matrix=new char[ceil(width*1.0/textWidth)][ceil(height*1.0/textHeight)];
  }
  void showMatrix() {
    background(0);
    for (int y=0; y<matrix[0].length; y++)
      for (int x=0; x<matrix.length; x++)
        text(matrix[x][y], textWidth*x, textHeight/2+textHeight*y);
  }
}
