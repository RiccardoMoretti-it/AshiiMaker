import processing.video.*; //libreria per implementazione  video //<>//

PImage image; //immagine o video (non relativo alla classe Ashii)
PGraphics blackwhite;
void setup() {
  //inzializza le variabili non relative alla calsse
  setupImages();
}
void draw() {
  background(0);
  pushMatrix();
  scale(scale);
  //disegna l'immagine o il frame del video
  image(image, 0, 0);
  image(blackwhite.get((int)(position.x), 0, (int)((width-position.x)), (int)(height)), (int)(position.x*scale), 0);
  
  checkCurtain();
  popMatrix();

  //disegna la tendina
  strokeWeight(2);
  line(position.x, 0, position.x, height);
  ellipse(position.x, position.y, size, size);
}
void checkCurtain() {
  if (press)
    position=new PVector(mouseX, mouseY);
}
void setImage() {
  //immagini contiene i nomi di tutti i file nella cartella /data
  String[] immagini;

  //sceglie a random un video o immagine
  File folder = new File(dataPath(""));
  immagini = folder.list(); //li trasformo in stringhe

  //ne prendo una a caso 
  int numero;
  do
    numero=(int)random(immagini.length);
  while (immagini[numero].split("\\.").length<2);
  //controlla se è un video o meno
  if (immagini[numero].split("\\.")[immagini[numero].split("\\.").length-1].equals("mp4")) {
    image=new Movie(this, immagini[numero]);
    Movie a=(Movie)image;
    a.loop();
    a.read();
  } else 
  image=loadImage(immagini[numero]);
  scale=displayWidth/image.width*0.6;
  if(scale>displayHeight/image.height*0.6)scale=displayHeight*1.0/image.height*0.6;
  surface.setSize((int)(image.width*scale),(int)(image.height*scale));
  blackwhite= createGraphics(width, height);
  blackwhite.beginDraw();
  PImage a=loadImage(immagini[numero]);
  blackwhite.image(blackWhite(a), 0, 0);
  blackwhite.endDraw();
  //metto le dimensioni della foto/video a quelle della finestra
}
void setupImages() {
  setImage();
  position=new PVector(width/2, height/2);
  size=(int)(displayWidth/50);
}
void movieEvent(Movie m) {
  m.read();
}

void mousePressed() {
  if (mouseButton==37)press=true;
  if (mouseButton==39)setImage();
}
void mouseReleased() {
  if (mouseButton==37)press=false;
}
PImage blackWhite(PImage image) {
  double redPart = 0.299;
  double greenPart = 0.587;
  double bluePart = 0.114;
  image.loadPixels();
  for (int i=0; i<image.pixels.length; i++)image.pixels[i]= color((int)(red(image.pixels[i])*redPart+green(image.pixels[i])*greenPart+blue(image.pixels[i])*bluePart));
  return image;
}
