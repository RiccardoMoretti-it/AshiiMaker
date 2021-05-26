Shape s=null;  
Campo campo=new Campo();
int frame=0,linee=0, velocita=24, punteggio=0;
int xMax;
int yMax;
boolean c;
int[] offset=new int[3];
boolean[] keys=new boolean[4];
void setup() {
  size(500, 600);
  xMax=width/20;
  yMax=height/24;
  stroke(0);
  strokeWeight(1);
  s=newShape();
  fill(0);
    toAscii=new Ascii(createFont("fonts//Console.ttf", fontSize), fontSize);

}
void draw() {
  //controlla se il gioco è finito
  c=true;
  for(int i=0;i<10;i++){
  if(campo.getCampo()[i][3]!=0)
  c=false;}
  if(c){
  //background rende la finestra vuota
  background(0);
  //creaCampo genera la griglia
 // creaCampo();
  if (s==null)s=newShape();
  int X=s.getX(), Y=s.getY();
  //stampa i pezzi fermi

  for (int x=0; x<10; x++)
    for (int y=4; y<24; y++)
      if (campo.getCampo()[x][y]!=0) {
        fill(campo.getCampo()[x][y]);
        rect(xMax*x, yMax*y, xMax, yMax);
      }

  //disegna la forma che sta cadendo
  fill(s.getColor());
  for (int x=0; x<4; x++)
    for (int y=0; y<4; y++)
      if (s.getBlock()[x][y])
        if(Y+y>=4)
        rect(xMax*x+X*xMax, yMax*y+Y*yMax, xMax, yMax);
  //keyPress
  if ((keys[0]&&(offset[0]==0||offset[0]%4==1))&&checkSide(X, Y, "sinistra"))s.Sposta("sinistra");
  if (keys[1]&&offset[2]==1){
    int k=0;   
    s.Routa();
    //se il pezzo esce dal bordo o ruota dentro un altro, il programma prova a spostarlo a sinistra, se non è possibile lo ruota indietro
    while(k<3&&(X-k<0||!checkDown(X-k,Y-1)))k++;
    //se k==4 non è stat possibile spostare il pezzo a sinistra
    if(k==4||X-k<0){
    while(k>0){ 
    s.Routa();
    k--;
    }}
    else while(k>0){
    s.Sposta("sinistra");
    k--;
    }
    

}
  if ((keys[2]&&(offset[0]==0||offset[0]%4==1))&&checkSide(X, Y, "destra"))
  s.Sposta("destra");
  if (keys[3]&&(offset[1]==0||offset[1]%4==1)) {
    if (checkDown(X, Y))s.Sposta("giu");
    else fermaPezzo();
    frame=0;
  }
  for (int i=0; i<2; i++)
    if (offset[i]>0)
      offset[i]++;
  if (offset[2]==1)
    offset[2]++;
  frame++;
  //ogni la velocita (che va aumentando) rappresenta il numero di frame che devono passare per far scendere il pezzo
  if (frame==velocita) {
    frame=0;
    if (checkDown(X, Y)) 
      s.Sposta("giu");
    else fermaPezzo();
  }
  }
  else ;

  toAscii.threading();
  toAscii.showMatrix();
}

//questo codice permette di memorizzare i tasti premuti senza usare keyCode in draw(), che invece memorizza solo 
//un tasto per volta,visto che keyPress viene richaimato per ogni carattere premuto da tastiera codice ripreso
//da https://forum.processing.org/two/discussion/22644/two-keys-pressed-three-keys-pressed-simultaneously
void keyPressed()
{
  
  toAscii.keyPressed();
  if (keyCode==32)
  s=null;
  if (keyCode==37) {
    keys[0]=true;
    if (offset[0]==0)offset[0]=1;
  }
  if (keyCode==38) {
    keys[1]=true;
    if (offset[2]==0)offset[2]=1;
  }
  if (keyCode==39) {
    keys[2]=true;
    if (offset[0]==0)offset[0]=1;
  }
  if (keyCode==40) {
    keys[3]=true;
    if (offset[1]==0)offset[1]=1;
  }
}
void keyReleased()
{
  if (keyCode==37) {
    keys[0]=false;
    offset[0]=0;
  }
  if (keyCode==38) {
    keys[1]=false;
    offset[2]=0;
  }
  if (keyCode==39) {
    keys[2]=false;
    offset[0]=0;
  }
  if (keyCode==40) {
    keys[3]=false;
    offset[1]=0;
  }
}
//dato "sinistra" o "destra" restituisce true se è possibile muovere il pezzo
//nella direzione data senza scontrarsi con altri pezzi(fermi)
boolean checkSide(int X, int Y, String direzione) {
  boolean check=true;
  for (int x=0; x<4; x++)
    for (int y=0; y<4; y++)
      if (s.getBlock()[x][y]) {
        if (direzione=="destra"&&x+X+1<=9) {
          if (campo.getCampo()[X+x+1][y+Y]!=0)
            check=false;
        } else if (direzione=="sinistra"&&(x+X+1<=9&&x+X-1>=0))
          if (campo.getCampo()[X+x-1][y+Y]!=0)
            check=false;
      }
  return check;
}
//Restituisce true se è possibile muovere il pezzo
//in giù senza scontrarsi con altri pezzi(fermi)
boolean checkDown(int X, int Y) {
  boolean check=true;
  for (int x=0; x<4; x++)
    for (int y=0; y<4; y++)
      if (s.getBlock()[x][y])
        if (y+Y+1<=23 &&x+X<=9) { 
          if (campo.getCampo()[X+x][y+Y+1]!=0)
            check=false;
        } else check=false;
  return check;
}
//salva la posizione dei pezzi fermi
void fermaPezzo() {
  for (int x=0; x<4; x++)
    for (int y=0; y<4; y++)
      if (s.getBlock()[x][y])campo.setBlocco(s.getX()+x, s.getY()+y, s.getColor());
  s=null;
  //controlla se vengono completate linee o effetuati tetris
  boolean check=false;
  int conta=0;
  for (int y=23; y>4; y--) {
    if (check)
    {
      removeLine(y+1);
      conta++;
      linee++;
    }
    check=true;
    for (int x=0; x<10; x++)
      if (campo.getCampo()[x][y]!=0) {
        fill(campo.getCampo()[x][y]);
        rect(xMax*x, yMax*y, xMax, yMax);
      } else check=false;
  }
}

void removeLine(int line) {
  Campo nuovo=new Campo();
  for(int y=23;y>0;y--)
    for(int x=0;x<10;x++)
      if(y>line)nuovo.setBlocco(x,y,campo.getCampo()[x][y]);
      else nuovo.setBlocco(x,y,campo.getCampo()[x][y-1]);
      campo=nuovo;
}



//crea la griglia che forma il campo(nessuna funzione pratica, solo grafica)
void creaCampo() {
  for (int x=1; x<=10; x++)line(xMax*x, 0, xMax*x, height);
  for (int y=4; y<24; y++)line(0, yMax*y, width/2, yMax*y);
textSize(32);
textAlign(LEFT);
text("Punteggio: "+punteggio, width/2, 100); 
}
//restituisce un nuovo pezzo, di coordinate definite in Shape, NON è 
//possibile usare, ad esempio, un vettore di tipo shapes contenentetutte
//le forme, in quanto i vettori, apparentemente, copiano dati come riferimento
Shape newShape() {
  Shape sh =new Shape();
  int r=(int)random(7);
  switch(r) {
  case 0:
    sh=new TShape();
    break;
  case 1:
    sh=new IShape();
    break;
  case 2:
    sh=new OShape();
    break;
  case 3:
    sh=new SShape();
    break;
  case 4:
    sh=new ZShape();
    break;
  case 5:
    sh=new JShape();
    break;
  case 6:
    sh=new LShape();
    break;
  }
  return sh;
}

void mousePressed() {
  toAscii.mousePressed();
}
void mouseReleased() {
  toAscii.mouseReleased();
}
