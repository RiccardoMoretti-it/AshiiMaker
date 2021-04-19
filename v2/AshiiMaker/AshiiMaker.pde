PImage image; //immagine o video (non relativo alla classe Ashii)
Ashii classe;
void setup() {
  //istanza della classe Ashii
  
  //inziializza le variabili non relative alla calsse
  setupImages();
  //metto le dimensioni della foto/video a quelle della finestra
  scale=(int)(displayHeight*0.8/image.height);
  if (image instanceof Movie)
    surface.setSize( image.height*scale, image.width*scale);
  else
    surface.setSize( image.width*scale, image.height*scale);
  classe=new Ashii(createFont("fonts//Console.ttf", fontSize),fontSize); 
}
void movieEvent(Movie m) {
  m.read();
}
void draw() {
  pushMatrix();
  if (image instanceof Movie) {
    translate(width, 0);
    rotate(PI/2);
  }
  scale(scale);
  //disegna l'immagine o il frame del video
  image(image, 0, 0);
  popMatrix();
  classe.threading();
  if (!mousePressed) 
  classe.showMatrix();
  println(frameRate);  

}
void keyPressed(){
print(" D"); //<>//
}


void setupImages(){

  //immagini contiene i nomi di tutti i file nella cartella /data
  String[] immagini;
  
  //sceglie a random un video o immagine
  File folder = new File(dataPath(""));
  immagini = folder.list(); //li trasformo in stringhe
  
  //ne prendo una a caso 
  int numero;
  do
    numero=(int)random(immagini.length);
  while(immagini[numero].split("\\.").length<2);
  //controlla se è un video o meno
    if (immagini[numero].split("\\.")[immagini[numero].split("\\.").length-1].equals("mp4")) {
    image=new Movie(this, immagini[numero]);
    Movie a=(Movie)image;
    a.loop();
    a.read();
  } else 
  image=loadImage(immagini[numero]);

}
