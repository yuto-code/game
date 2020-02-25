class Enemy{
  //enemy's defalt infomation
  float x;
  float y;
  int angle;
  int hitPoint=30;
  
  Enemy(float x,float y,int angle,int hitPoint){
    this.x=x;
    this.y=y;
    this.angle=angle;
    this.hitPoint=hitPoint;
  }
  
  //move infinite shape
  void move(){
    angle=(angle+1)%360;
    x+=cos(radians(angle))*3;
    y+=sin(radians(angle*2+90))*4.5;
  }
  
  boolean deleteEnemy(){
    return hitPoint<=0;
  }
}

//circle shot
class Enemy1 extends Enemy{
  Enemy1(float x,float y,int angle,int hitPoint){
    super(x,y,angle,hitPoint);
  }
  int maxHP=hitPoint;
  float nowHP;
  
  void draw(){
    image(enemy1Img,x,y,55,55);
    if(frameCount%90==0) circleShot();
    
    nowHP=(float)hitPoint/(float)maxHP;
    fill(0,255,0);
    rect(x-25,y-30,nowHP*50,5);
    fill(255,0,0);
    rect(x-25+nowHP*50,y-30,(1-nowHP)*50,5);
    
    //draw bullet
    fill(255,0,0);
    for(int i=bulletList1.size()-1;i>=0;i--){
      Bullet1 bullet=bulletList1.get(i);
      bullet.move();
      bullet.draw();
      //collision judgement
      if(collision(player.x,player.y,20,20,bullet.x,bullet.y,3,3)){
        bullet.hit=true;
        if(!player.isEffected2 && !playerHit){
          player.hitPoint-=10;
          audio6.play();
          audio6.rewind();
          playerHit=true;
        }
      }
      if(bullet.needRemove() || hitPoint<=0) bulletList1.remove(i); //delete bullet
    }
    
    //if enemy get item , extinction
    if(itemFlag && collision(item.x,item.y,item.w,item.h,this.x,this.y,40,40)){
      itemFlag=false;
      audio4.play();
      audio4.rewind();
    }
      
    if(itemFlag2 && collision(item.x2,item.y2,item.w2,item.h2,this.x,this.y,40,40)){
      itemFlag2=false;
      audio4.play();
      audio4.rewind();
    }
      
    if(itemFlag3 && collision(item.x3,item.y3,item.w3,item.h3,this.x,this.y,40,40)){
      itemFlag3=false;
      audio4.play();
      audio4.rewind();
    }
    
    if(keyFlag && collision(item.keyx,item.keyy,item.keyw,item.keyh,this.x,this.y,40,40)){
      keyFlag=false;
      hitPoint=30;
      audio4.play();
      audio4.rewind();
      keyTime=0;
    }
  }
    
  void circleShot(){
    //bullets generate. 10deg is shihted from 0~350deg
    for(float angle=0;angle<360;angle+=36){
      Bullet1 bullet=new Bullet1(x,y,angle,2,0);
      bulletList1.add(bullet);
    }
  }
}

//snipe shot
class Enemy2 extends Enemy{
  float degree;
  float dx=random(50,950),dy=random(50,700); //movement distination
  float dx2,dy2; //movement distination - present location
  
  Enemy2(float x,float y,int angle,int hitPoint){
    super(x,y,angle,hitPoint);
  }
  int maxHP=hitPoint;
  float nowHP;
  
  //move random
  void move(){
    dx2=dx-x;
    dy2=dy-y;
    if(abs(dx2)<=5 && abs(dy2)<=5){
      dx=random(50,950);
      dy=random(50,700);
    }
    degree=degrees(atan2(dy2,dx2));
    x+=cos(radians(degree))*1.7; //angle X * speed = x
    y+=sin(radians(degree))*1.7; 
  }
  
  void draw(){
    image(enemy2Img,x,y,50,50);
    if(frameCount%120==0) snipeShot();
    
    nowHP=(float)hitPoint/(float)maxHP;
    fill(0,255,0);
    rect(x-25,y-27,nowHP*50,5);
    fill(255,0,0);
    rect(x-25+nowHP*50,y-27,(1-nowHP)*50,5);
    
    //draw bullet
    fill(255,0,0);
    for(int i=bulletList2.size()-1;i>=0;i--){
      Bullet2 bullet=bulletList2.get(i);
      bullet.move();
      bullet.draw();
      //collision judgement
      if(collision(player.x,player.y,20,20,bullet.x,bullet.y,4,4)){
        bullet.hit=true;
        if(!player.isEffected2 && !playerHit){
          player.hitPoint-=10;
          audio6.play();
          audio6.rewind();
          playerHit=true;
        }
      }
      if(bullet.needRemove() || hitPoint<=0) bulletList2.remove(bullet); //delete bullet
    }
    
    //if enemy get item , extinction
    if(itemFlag && collision(item.x,item.y,item.w,item.h,this.x,this.y,40,40)){
      itemFlag=false;
      audio4.play();
      audio4.rewind();
    }
      
    if(itemFlag2 && collision(item.x2,item.y2,item.w2,item.h2,this.x,this.y,40,40)){
      itemFlag2=false;
      audio4.play();
      audio4.rewind();
    }
      
    if(itemFlag3 && collision(item.x3,item.y3,item.w3,item.h3,this.x,this.y,40,40)){
      itemFlag3=false;
      audio4.play();
      audio4.rewind();
    }
    
    if(keyFlag && collision(item.keyx,item.keyy,item.keyw,item.keyh,this.x,this.y,40,40)){
      keyFlag=false;
      hitPoint=30;
      audio4.play();
      audio4.rewind();
      keyTime=0;
    }
  }
  void snipeShot(){
    float dx=player.x-x;
    float dy=player.y-y;
    float degree=degrees(atan2(dy,dx));
    Bullet2 bullet=new Bullet2(x,y,degree,2,0);
    bulletList2.add(bullet);
  }
}

class Enemy3 extends Enemy{
  float degree;
  float dx=random(50,950),dy=random(50,700); //movement distination
  float dx2,dy2; //movement distination - present location
  
  Enemy3(float x,float y,int angle,int hitPoint){
    super(x,y,angle,hitPoint);
  }
  int maxHP=hitPoint;
  float nowHP;
  
  //move random
  void move(){
    dx2=dx-x;
    dy2=dy-y;
    if(abs(dx2)<=5 && abs(dy2)<=5){
      dx=random(50,950);
      dy=random(50,700);
    }
    degree=degrees(atan2(dy2,dx2));
    x+=cos(radians(degree))*1.7; //angle X * speed = x
    y+=sin(radians(degree))*1.7;
  }
  
  void draw(){
    image(enemy3Img,x,y,50,50);
    if(frameCount%10==0) randomShot();
    
    nowHP=(float)hitPoint/(float)maxHP;
    fill(0,255,0);
    rect(x-25,y-33,nowHP*50,5);
    fill(255,0,0);
    rect(x-25+nowHP*50,y-33,(1-nowHP)*50,5);
    
    //draw bullet
    fill(255,0,0);
    for(int i=bulletList3.size()-1;i>=0;i--){
      Bullet3 bullet=bulletList3.get(i);
      bullet.move();
      bullet.draw();
      //collision judgement
      if(collision(player.x,player.y,20,20,bullet.x,bullet.y,4,4)){
        bullet.hit=true;
        if(!player.isEffected2 && !playerHit){
          player.hitPoint-=10;
          audio6.play();
          audio6.rewind();
          playerHit=true;
        }
      }
      if(bullet.needRemove() || hitPoint<=0) bulletList3.remove(bullet); //delete bullet
    }
    
      //if enemy get item , extinction
    if(itemFlag && collision(item.x,item.y,item.w,item.h,this.x,this.y,40,40)){
      itemFlag=false;
      audio4.play();
      audio4.rewind();
    }
      
    if(itemFlag2 && collision(item.x2,item.y2,item.w2,item.h2,this.x,this.y,40,40)){
      itemFlag2=false;
      audio4.play();
      audio4.rewind();
    }
      
    if(itemFlag3 && collision(item.x3,item.y3,item.w3,item.h3,this.x,this.y,40,40)){
      itemFlag3=false;
      audio4.play();
      audio4.rewind();
    }
    
    if(keyFlag && collision(item.keyx,item.keyy,item.keyw,item.keyh,this.x,this.y,40,40)){
      keyFlag=false;
      hitPoint=30;
      audio4.play();
      audio4.rewind();
      keyTime=0;
    }
  }
  void randomShot(){
    degree=random(0,360);
    Bullet3 bullet=new Bullet3(x,y,degree,2,0);
    bulletList3.add(bullet);
  }
}