char[] greyScale;
//i simboli che verranno confrontati
//1234567890qwertyuiopè+asdfghjklòàùzxcvbnm,.-QWERTYUIOOPé*ASDFGHJKLç°§>ZXCVBNM;:_!$%&=^@#+°
String alfabeto="1234567890qwertyuiopè+asdfghjklòàùzxcvbnm,.-QWERTYUIOOPé*ASDFGHJKLç°§>ZXCVBNM;:_!$%&=^@#+";
float textHeight=11, textWidth;PFont p;

//Il programma prende un insieme di caratteri da alfabeto li ordina in base a
//quanto "spazio" occupano, o quanto colore immettono se premuti, esempio:
//(.-_,) avranno un valore molto basso in quanto piccoli, (#@QRM) il contrario
//utile per renderizzare immagini in ascii

void setup() {
  greyScale=new char[alfabeto.split("").length];
  for(int i=0;i<alfabeto.split("").length;i++)  
    greyScale[i]=alfabeto.charAt(i);
 
  p=createFont("Consolas.ttf", textHeight);
  //altezza del carattere
  textFont(p);   
  //larghezza del carattere
  textWidth=textWidth("@");
  size(250,250);
  text(greyScale[0],width*1/3,height*1/3);
  set(0,0,color(255));
  compute();
}
void draw(){
  text("(",width*4/5,height*1/3);
  text(")",width*2/3,height*1/3);
}
int []values;
void compute(){
  values=new int[greyScale.length];
  for(int i=0;i<greyScale.length;i++) values[i]=0;
  for(int i=0;i<greyScale.length;i++){
  fill(0);
    background(255);
  text(greyScale[i],width*1/3,height*1/3);
    for(int x=0;x<width-1;x++)
      for(int y=0;y<height-1;y++){
        color c=get(x,y);
        if(red(c)!=255|| blue(c)!=255 || green(c)!=255)      
          values[i]=values[i]+1;
        }
  }
  //ordina in base alla presenza di colore
  for(int x=1;x<greyScale.length;x++)
      for (int i=0; i<x; i++) {
        if (values[x]<values[i]) {
          int copia=values[x];
          //shift
          for (int o=x; o>i; o--) {
            char appoggioC=greyScale[o];
            greyScale[o]=greyScale[o-1];
            greyScale[o-1]=appoggioC;
            int appoggio=values[o];
            values[o]=values[o-1];
            values[o-1]=appoggio;
          }
          values[i]=copia;
          break;
        }
  }
  ///rimuove i valori doppi
  
  //conta i numeri senza doppi e riduce ad una scala 0-255
  int size=1;
  for(int i=1;i<greyScale.length;i++){
    if(values[i]==values[i-1])
      values[i-1]=0;
    else{
    values[i-1]=(int)map(values[i-1],values[0],values[values.length-1],0,255);
    size++;
    }
  }
//restituisce il vettore
  for(int i=0;i<greyScale.length;i++)
    print(greyScale[i]);
  
  //ricrea il vettore senza doppi
  values[values.length-1]=255;
  char[] newGreyScale=new char[size];
  int[] newValues=new int[size];
  newValues[0]=values[0];
  newGreyScale[0]=greyScale[0];
  int counter=0;
  for(int i=1;i<greyScale.length;i++){
    if(values[i]!=0){
      newValues[++counter]=values[i];
      newGreyScale[counter]=greyScale[i];
    }
}
println("\n\n\nordered\n");
    greyScale=newGreyScale;
    values=newValues;
  for(int i=0;i<greyScale.length;i++)
    print(greyScale[i]);
    println();
  for(int i=0;i<greyScale.length;i++)
    print(values[i]+" ");
//ricrea il vettore con 255 posti per l'uso
  newGreyScale=new char[255];
  int c=0;
      for(int y=0;y<255;y++){
        if(!(c==greyScale.length-1)&& (y>values[c]+(values[c+1]-values[c])/2))
        c++;
        newGreyScale[y]=greyScale[c];
        if(c==greyScale.length-1)
        print();
    }
    println("orcodio\n");
//restituisce il vettore
    greyScale=newGreyScale;
  for(int i=0;i<greyScale.length;i++)
    print(greyScale[i]);
    println();
  for(int i=0;i<values.length;i++)
    print(values[i]+" ");
}
