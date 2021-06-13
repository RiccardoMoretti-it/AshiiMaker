import java.util.Date;
import processing.video.*;


PImage image;
//@#*+=:-. //@MBHENR#KWXDFPQASUZbdehx*8Gm&04LOVYkpq5Tagns69owz$CIu23Jcfry%1v7l+it[]{}?j|()=~!-/<>\"^_';,:`. //
char[] greyScale="        ''''''''..................------------\"\"\"\"\"\"\"\"\"\"\"^^^^^_________LLLLLLLLLTTTT+++++IIIII1111EEEEEYYYYZZZZZ££££nnnnnooooPPPPPAAAAARRRRDDDDDbbbbOOOOOBBBB$$$$$$$88888880000000&&&&&&&&&&&&&&&&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@".toCharArray() ;
Ashii classe;
char [][]matrix;
void setup() {
  String[] immagini;
  classe=new Ashii(createFont("fonts//Console.ttf", 11),11);

  //sceglie a random un video o immagine

  //ottengo tutti i file in images
  File folder = new File(dataPath(""));
  immagini = folder.list(); //li trasformo in stringhe


  //ne prendo una a caso 
  int numero;
  do{
  numero=(int)random(immagini.length);
  }while(immagini[numero].split("\\.").length<2);

    if (immagini[numero].split("\\.")[immagini[numero].split("\\.").length-1].equals("mp4")) {
    image=new Movie(this, immagini[numero]);
    Movie a=(Movie)image;
    a.loop();
    a.read();
  } else 
  image=loadImage(immagini[numero]);

  //metto le dimensioni della foto/video a quelle della finestra
  if (image instanceof Movie)
    surface.setSize( image.height*2, image.width*2);
  else
    surface.setSize( image.width*2, image.height*2);
  classe.Matrix();
}
void movieEvent(Movie m) {
  m.read();
}
void draw() {
  pushMatrix();
  background(0); 
  if (image instanceof Movie) {
    translate(width, 0);
    rotate(PI/2);
  }
  scale(2);
  image(image, 0, 0);
  popMatrix();
  if (!mousePressed);
  if(frameCount==1)classe.threading();
  classe.showMatrix(); //<>//
}
