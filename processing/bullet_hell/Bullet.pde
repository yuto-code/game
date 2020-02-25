//circle shot
class Bullet1{
  float x; //x coordinate
  float y; //y coordinate
  float angle; //angle
  int speed;
  int angleSpeed;
  
  //defaults
  Bullet1(float x,float y,float angle,int speed,int angleSpeed){
    this.x=x;
    this.y=y;
    this.angle=angle;
    this.speed=speed;
    this.angleSpeed=angleSpeed;
  }
  
  void move(){
    angle=(angle+angleSpeed)%360; //angle changes by angular speed
    x+=cos(radians(angle))*speed; //angle X * speed = x
    y+=sin(radians(angle))*speed; //angle Y * speed = y
  }
  
  void draw(){
    image(bullet1,x,y,10,10);
  }
  boolean hit=false; //player hit flag
  
  //delete bullet
  boolean needRemove(){
    //out of window or player hit
    return x<0 || x>width || y<0 || y>height || hit || finishFlag2;
  }
}

//snipe shot
class Bullet2{
  float x; //x coordinate
  float y; //y coordinate
  float angle; //angle
  int speed;
  int angleSpeed;
  
  //defaults
  Bullet2(float x,float y,float angle,int speed,int angleSpeed){
    this.x=x;
    this.y=y;
    this.angle=angle;
    this.speed=speed;
    this.angleSpeed=angleSpeed;
  }
  
  void move(){
    angle=(angle+angleSpeed)%360; //angle changes by angular speed
    x+=cos(radians(angle))*speed; //angle X * speed = x
    y+=sin(radians(angle))*speed; //angle Y * speed = y
  }
  
  void draw(){
    image(bullet2,x,y,10,10);
  }
  boolean hit=false; //player hit flag
  
  //delete bullet
  boolean needRemove(){
    //out of window or player hit
    return x<0 || x>width || y<0 || y>height || hit || finishFlag2;
  }
}

//random shot
class Bullet3{
  float x; //x coordinate
  float y; //y coordinate
  float angle; //angle
  int speed;
  int angleSpeed;
  
  //defaults
  Bullet3(float x,float y,float angle,int speed,int angleSpeed){
    this.x=x;
    this.y=y;
    this.angle=angle;
    this.speed=speed;
    this.angleSpeed=angleSpeed;
  }
  
  void move(){
    angle=(angle+angleSpeed)%360; //angle changes by angular speed
    x+=cos(radians(angle))*speed; //angle X * speed = x
    y+=sin(radians(angle))*speed; //angle Y * speed = y
  }
  
  void draw(){
    image(bullet3,x,y,10,10);
  }
  boolean hit=false; //player hit flag
  
  //delete bullet
  boolean needRemove(){
    //out of window or player hit
    return x<0 || x>width || y<0 || y>height || hit || finishFlag2;
  }
}

//laser shot
class Laser extends Bullet1{
  float w;
  float h;
  float speed;
  
  Laser(float x,float y,float angle,float w,float h){
    super(x,y,angle,3,0);
    this.w=w;
    this.h=h;
  }
  
  void move(){
    if(player.isEffected4)
      speed=12;
    else
      speed=6;
    angle=(angle+angleSpeed)%360; //angle changes by angular speed
    x+=cos(radians(angle))*speed; //angle X * speed = x
    y+=sin(radians(angle))*speed; //angle Y * speed = y
  }
  
  void draw(){
    rect(x-w/2,y-h/2,w,h);
  }
}