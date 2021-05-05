import processing.video.*; //libreria per implementazione  video

PImage image; //immagine o video (non relativo alla classe Ascii)
Ascii toAscii;
void setup() {
  //inzializza le variabili non relative alla calsse
  setupImages();
  toAscii=new Ascii(createFont("fonts//Console.ttf", fontSize),fontSize); 
}
void draw() {
  //disegna l'immagine o il frame del video
 image(image, 0, 0);
  toAscii.threading();
  toAscii.showMatrix();
  println(frameRate);
}
void setImage() {
  //immagini contiene i nomi di tutti i file nella cartella /data
  String[] immagini; //<>//

  //sceglie a random un video o immagine
  File folder = new File(dataPath(""));
  immagini = folder.list(); //li trasformo in stringhe

  //ne prendo una a caso 
  int numero;
  do
    numero=(int)random(immagini.length);
  while (immagini[numero].split("\\.").length<2);
  //controlla se è un video o meno
  float scale;
  if (immagini[numero].split("\\.")[immagini[numero].split("\\.").length-1].equals("mp4")) {
    image=new Movie(this, immagini[numero]);
    Movie a=(Movie)image;
    a.loop();
    a.read();
    scale=1;
  } else {
  image=loadImage(immagini[numero]);
  println(image.width+" "+image.height);
  //setta la dimensione della dinestra
  scale=displayWidth/image.width*0.6;
  if(scale>displayHeight/image.height*0.6)scale=displayHeight*1.0/image.height*0.6;
 }
  surface.setSize((int)(image.width*scale),(int)(image.height*scale));
  //ridimensione le immagini
  image.resize(width, height);
  if(image instanceof Movie){
    Movie a=(Movie)image;
    a.loop();}
}
void setupImages() {
  setImage();
}
void movieEvent(Movie m) {
  m.read();
}
void mousePressed() {
  toAscii.mousePressed();
}
void mouseReleased() {
  toAscii.mouseReleased();
}
void keyPressed(){
  toAscii.keyPressed();
}
