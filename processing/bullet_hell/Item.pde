class Item{
  //default of item1
  float x;
  float y;
  float w;
  float h;
  float degree;
  float dx=random(50,950),dy=random(50,700); //movement distination
  float dx2,dy2; //movement distination - present location
  //default of item2
  float x2;
  float y2;
  float w2;
  float h2;
  float degree2;
  float dx_2=random(50,950),dy_2=random(50,700); //movement distination
  float dx2_2,dy2_2; //movement distination - present location
  //default of item3
  float x3;
  float y3;
  float w3;
  float h3;
  float degree3;
  float dx_3=random(50,950),dy_3=random(50,700); //movement distination
  float dx2_3,dy2_3; //movement distination - present location
  //default of k
  float keyx;
  float keyy;
  float keyw;
  float keyh;
  float keydegree;
  float keydx=random(50,950),keydy=random(50,700); //movement distination
  float keydx2,keydy2; //movement distination - present location
  float keySpeed=random(2,3);
  //default
  Item(){
    this.x=random(100,width-100);
    this.y=random(100,300);
    this.w=24;
    this.h=24;
    this.x2=random(100,width-100);
    this.y2=random(100,300);
    this.w2=24;
    this.h2=24;
    this.x3=random(100,width-100);
    this.y3=random(100,300);
    this.w3=24;
    this.h3=24;
    this.keyx=random(100,width-100);
    this.keyy=random(100,300);
    this.keyw=24;
    this.keyh=24;
  }
  
  //move random
  void move(){
    //move item1
    dx2=dx-x;
    dy2=dy-y;
    if(abs(dx2)<=5 && abs(dy2)<=5){
      dx=random(50,950);
      dy=random(50,700);
    }
    degree=degrees(atan2(dy2,dx2));
    x+=cos(radians(degree))*1.5; //angle X * speed = x
    y+=sin(radians(degree))*1.5; 
    //move item2
    dx2_2=dx_2-x2;
    dy2_2=dy_2-y2;
    if(abs(dx2_2)<=5 && abs(dy2_2)<=5){
      dx_2=random(50,950);
      dy_2=random(50,700);
    }
    degree2=degrees(atan2(dy2_2,dx2_2));
    x2+=cos(radians(degree2))*1.5; //angle X * speed = x
    y2+=sin(radians(degree2))*1.5; 
    //move item3
    dx2_3=dx_3-x3;
    dy2_3=dy_3-y3;
    if(abs(dx2_3)<=5 && abs(dy2_3)<=5){
      dx_3=random(50,950);
      dy_3=random(50,700);
    }
    degree3=degrees(atan2(dy2_3,dx2_3));
    x3+=cos(radians(degree3))*1.5; //angle X * speed = x
    y3+=sin(radians(degree3))*1.5; 
    //move key
    keydx2=keydx-keyx;
    keydy2=keydy-keyy;
    if(abs(keydx2)<=5 && abs(keydy2)<=5){
      keydx=random(50,950);
      keydy=random(50,700);
    }
    keydegree=degrees(atan2(keydy2,keydx2));
    keyx+=cos(radians(keydegree))*keySpeed; //angle X * speed = x
    keyy+=sin(radians(keydegree))*keySpeed; 
  }
  
  void draw(){
    //draw item1
    if(itemFlag)
      image(tresure,x,y);
    //draw item2
    if(itemFlag2)
     image(tresure,x2,y2);
    //draw item3
    if(itemFlag3)
      image(tresure,x3,y3);
    if(keyFlag){
      if(keyTime>=7){
        if(frameCount%2==0)
          image(Key,keyx,keyy);
      }
      else
        image(Key,keyx,keyy);
      if(keyTime<=5)
      image(cursor,keyx,keyy-50,20,64);
    }
  }
}