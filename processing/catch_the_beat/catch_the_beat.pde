import ddf.minim.*;
import processing.opengl.*;
import processing.serial.*;
import cc.arduino.*;

static Minim minim;
static ResourceLoader resourceLoader;
static SceneController sceneController;
//Arduino arduino;
Serial port; 
int deg_x,deg_y;
int deg_s=10;

void settings()
{
  size(displayHeight*4/3, displayHeight);
}

void setup()
{
  //size(1300, 750);
  allInitialize();
  println(Serial.list());
  String arduinoPort = Serial.list()[0];
  port = new Serial(this, arduinoPort, 9600);
}

void draw()
{
  background(28);
  sceneController.update();
}

void stop() {
  for(AudioSample bs : resourceLoader.beatSound_)
  {
    bs.close();
  }
  minim.stop();
  super.stop();
}

void allInitialize(){
  minim = new Minim(this);
  resourceLoader = new ResourceLoader();
  sceneController = new SceneController();
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