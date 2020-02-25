import processing.opengl.*;
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
Serial port; 
int inByte;
int deg_x,deg_y;
int deg_s=10;
int x,y;
float rotX, rotY, rotZ;

void setup(){
  size(1000,1000,OPENGL);
  println(Serial.list());
  String arduinoPort = Serial.list()[0];
  port = new Serial(this, arduinoPort, 9600);
  frameRate(60);
  fill(63,127,255);
  stroke(255);
  rectMode(CENTER);
  rotX =90;
  rotY =0;
}

void draw(){
  background(0,0,0);
  translate(width/2,height/2);
  if(deg_x<-deg_s){
    x=-1;
  }else if(deg_x>deg_s){
    x=1;
  }else{
    x=0;
  }
  if(deg_y<-deg_s){
    y=-1;
  }else if(deg_y>deg_s){
    y=1;
  }else{
    y=0;
  }
  rotX=90+deg_x;
  rotY=-deg_y;
  rotateX(radians(rotX));
  rotateY(radians(rotY));
  rect(0,0,width/2,height/2);
  println("deg_x:"+deg_x+"\t"+"deg_y:"+deg_y+"\t\t"+"deg_x_1/0/-1:"+x+"\t"+"deg_y_1/0/-1:"+y);    
}

int deg_x1,deg_x2;//x1:down,x2:up
int deg_y1,deg_y2;//y1:down,y2:up
int a,b,c,d;
void serialEvent(Serial port){
  if ( port.available() > 4 ) {
      a=port.read();
      b=port.read();
      c=port.read();
      d=port.read();
  }
  deg(a);deg(b);deg(c);deg(d);
  
  if((deg_x2&128)==128){
    deg_x=-((deg_x1&15)|((deg_x2&15)<<4));
  }else{
    deg_x=(deg_x1&15)|((deg_x2&15)<<4);
  }
  if((deg_y2&128)==128){
    deg_y=-((deg_y1&15)|((deg_y2&15)<<4));
  }else{
    deg_y=(deg_y1&15)|((deg_y2&15)<<4);
  }  
}
void deg(int j){
  if((j&112)==0){deg_x1=j;}
  else if((j&112)==16){deg_x2=j;}
  else if((j&112)==32){deg_y1=j;}
  else if((j&112)==48){deg_y2=j;}
}