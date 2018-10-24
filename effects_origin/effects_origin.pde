PFont font;
Rain[] rains = new Rain[10000];
Snow[] snows = new Snow[10000];
String data;
String ame;
String konnnitiha;
String yuki;
String maru;
String enn;
String sankaku;
String sankakkei;
String sikaku;
String sikakkei;
String imanannzi;
String nanngatu;
String nannniti;
String kyou;
String asita;
String asatte;
String kinou;
int i,k;

void setup(){
 size(500, 500);
 smooth();
 background(255);
 fill(120);
 font=createFont("MS Mincho",48,true);
 textFont(font,48);
 textAlign(CENTER);
 data =new String();

 for(int i=0; i<rains.length; i++){
   Rain rain = new Rain();
   rain.x = random(0, 500);
   rain.y = 0;
   rains[i] = rain;}

  for(int i=0; i<snows.length; i++){
   Snow snow = new Snow();
   snow.a = random(0, 500);
   snow.b = 0;
   snows[i] = snow;
 }

 ame="ame";
 konnnitiha="konnnitiha";
 yuki="yuki";
 maru="maru";
 enn="enn";
 sankaku="sankaku";
 sankakkei="sankakkei";
 sikakkei="sikakkei";
 sikaku="sikaku";
 imanannzi="imanannzi";
 nanngatu="nanngatu";
 nannniti="nannniti";
 kyou="kyou";
 asita="asita";
 asatte="asatte";
 kinou="kinou";
}

void draw(){
k++;
if(data.equals(yuki)){
background(0);
textSize(60);
text("雪",235,250);
textSize(30);
text("|Yuki|",235,285);
fill(150);
k--;
 for(int i=0; i<snows.length; i++){
   if(i < (2*(frameCount-k))){
     snows[i].disp();
     if(i%2==0){snows[i].fall1();}
     else{snows[i].fall2();}
   }
 }


}else if(data.equals(ame)){
background(255);
textSize(60);
text("雨",240,250);
textSize(30);
text("|Ame|",240,285);
k--;
 for(int i=0; i<rains.length; i++){
   if(i < 2*(frameCount-k)){
     if(i%2==0){rains[i].disp1();}
     else{rains[i].disp2();}
     if(i%2==0){rains[i].fall1();}
     else{rains[i].fall2();} } }


}else if(data.equals(maru)||data.equals(enn)){
fill(255);
ellipse(250,250,200,200);
fill(120);
text("丸　円",0,200,width, height);
}else if(data.equals(sankaku)||data.equals(sankakkei)){
fill(255);
triangle(250,50,450,450,50,450);
fill(120);
text("三角形",0,200,width, height);
}else if(data.equals(sikaku)||data.equals(sikakkei)){
text("四角形",0,200,width, height);
}else if(data.equals(konnnitiha)){
text("Hello!",0,200,width, height);
}else if(data.equals(imanannzi)){
background(255);
text (hour() + ":" + nf(minute(), 2) + ":" + nf(second(), 2),0,200,width,height);
}else if(data.equals(nanngatu)){
text(month()+"月"+","+day()+"日",0,200,width,height);
}else if(data.equals(nannniti)||data.equals(kyou)){
text(""+day()+"日",0,200,width,height);
}else if(data.equals(asita)){
text(day()+1+"日",0,200,width,height);
}else if(data.equals(asatte)){
text(day()+2+"日",0,200,width,height);
}else if(i>=20){text("20＋",0,200,width,height);
}else{text(data,0,0,width, height);
}
}


void keyPressed(){
 background(255);
 data += key;
 i++;
}

class Rain{
 float x;
 float y;

 void disp1(){
   stroke(120);
   strokeWeight(1);
   line(x,y,x+1.5,y+25);
 }

 void disp2(){
   stroke(120);
   strokeWeight(1);
   line(x,y,x-1.5,y+30);
 }

 void fall1(){
   y=y+5;
   x=x+0.01;
 }

 void fall2(){
   y+=5;
   x=x-0.01;
 }
}

class Snow{
 float a;
 float b;

 void disp(){
   noStroke();
   ellipse(a,b,5,5);
 }

 void fall1(){
   b++;
   a=a+random(0.01,0.15);
 }

 void fall2(){
   b++;
   a=a-random(0.01,0.15);
 }

}
