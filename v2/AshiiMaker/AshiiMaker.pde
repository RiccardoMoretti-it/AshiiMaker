import processing.video.*; //libreria per implementazione  video //<>//
  
PImage image; //immagine o video (non relativo alla classe Ascii)
Ascii toAscii; 
Capture cam;

void setup() { 

  //inzializza le variabili non relative alla calsse
    randomImage();
  toAscii=new Ascii(createFont("fonts//Console.ttf", fontSize), fontSize);
}
void draw() {
  //disegna l'immagine o il frame del video
  if (image instanceof Capture)
    ((Capture)image).read();
  image(image, 0, 0);
  
  toAscii.threading();
  toAscii.showMatrix();
}
  //controlla se è un video o meno
  float scale=1;
void setImage() {
  if (!(image instanceof Movie) && !(image instanceof Capture)){
    scale=displayWidth/image.width*0.4;
    if (scale>displayHeight/image.height*0.6)scale=displayHeight*1.0/image.height*0.6;
  }  
  surface.setSize((int)(image.width*scale), (int)(image.height*scale));
  //ridimensione le immagini
  image.resize(width, height);
  if (image instanceof Movie) {
    Movie a=(Movie)image;
    a.loop();
  }
}
void randomImage(){
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
  
  //camera
  if (camera) {
    cam = new Capture(this, "pipeline:autovideosrc");
    cam.start(); 
    image=cam;
  } 
  //video
  else if (immagini[numero].split("\\.")[immagini[numero].split("\\.").length-1].equals("mp4")) {
    image=new Movie(this, immagini[numero]);
    Movie a=(Movie)image;
    a.loop();
    a.read();
    scale=1;
  }
  //immagine
  else {
    image=loadImage(immagini[numero]);
    //setta la dimensione della dinestra
    scale=displayWidth/image.width*0.4;
    if (scale>displayHeight/image.height*0.6)scale=displayHeight*1.0/image.height*0.6;
  }
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
void keyPressed() {
  toAscii.keyPressed();
}
