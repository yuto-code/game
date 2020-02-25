class Boss{
  //enemy's defalt infomation
  float x;
  float y;
  int angle;
  int hitPoint=100;
  int maxHP=hitPoint;
  float nowHP;
  float degree;
  float dx=random(50,950),dy=random(50,700); //movement distination
  float dx2,dy2; //movement distination - present location
  
  Boss(float x,float y,int angle,int hitPoint){
    this.x=x;
    this.y=y;
    this.angle=angle;
    this.hitPoint=hitPoint;
  }
  
  //move random
  void move(){
    dx2=dx-x;
    dy2=dy-y;
    if(abs(dx2)<=5 && abs(dy2)<=5){
      dx=random(50,950);
      dy=random(50,700);
    }
    if(bossFlag1){
      degree=degrees(atan2(dy2,dx2));
      x+=cos(radians(degree))*8; //angle X * speed = x
      y+=sin(radians(degree))*8;
    }
    if(!bossFlag1){
      degree=degrees(atan2(dy2,dx2));
      x+=cos(radians(degree))*4; //angle X * speed = x
      y+=sin(radians(degree))*4;
    }
  }
  
  void draw(){
    if(bossFlag2){
      colorMode(HSB);
      tint(rainbow,255,255);
      rainbow=(rainbow+1)%101;
      colorMode(RGB);
    }
    image(bossImg,x,y,192,90);
    noTint();
    if(bossFlag3){
      if(frameCount%5==0) randomShot();
      if(frameCount%50==0) snipeShot();
      if(frameCount%70==0) circleShot();
    }
    if(!bossFlag3){
      if(frameCount%10==0) randomShot();
      if(frameCount%100==0) snipeShot();
      if(frameCount%90==0) circleShot();
    }
    
    nowHP=(float)hitPoint/maxHP;
    fill(255,0,0);
    rect(20,10,nowHP*200,30);
    fill(0,0,0);
    rect(20+nowHP*200,10,(1-nowHP)*200,30);
    
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
    
    //benefit from item
    if(itemFlag && collision(item.x,item.y,item.w,item.h,this.x,this.y,150,50)){
      itemFlag=false;
      audio4.play();
      audio4.rewind();
      if(!bossFlag2 && !bossFlag3)
        bossFlag1=true;
      bossEffectTime=0;
    }
      
    if(itemFlag2 && collision(item.x2,item.y2,item.w2,item.h2,this.x,this.y,150,50)){
      itemFlag2=false;
      audio4.play();
      audio4.rewind();
      if(!bossFlag1 && !bossFlag3){
        bossFlag2=true;
        bossHitCount=0;
      }
      bossEffectTime=0;
    }
      
    if(itemFlag3 && collision(item.x3,item.y3,item.w3,item.h3,this.x,this.y,150,50)){
      itemFlag3=false;
      audio4.play();
      audio4.rewind();
      if(!bossFlag1 && !bossFlag2)
        bossFlag3=true;
      bossEffectTime=0;
    }
    
    if(keyFlag && collision(item.keyx,item.keyy,item.keyw,item.keyh,this.x,this.y,150,50)){
      keyFlag=false;
      bossFlag1=false;
      bossFlag2=false;
      bossFlag3=false;
      audio4.play();
      audio4.rewind();
      if(hitPoint<=7) hitPoint+=3;
      bossFlag1=true;
      bossFlag2=true;
      bossFlag3=true;
      bossEffectTime=0;
      keyTime=0;
    }
  }
  
   void circleShot(){
    //bullets generate. 10deg is shihted from 0~350deg
    for(float angle=0;angle<360;angle+=18){
      Bullet1 bullet=new Bullet1(x,y,angle,2,0);
      bulletList1.add(bullet);
    }
  }
  void snipeShot(){
    float dx=player.x-x;
    float dy=player.y-y;
    float degree=degrees(atan2(dy,dx));
    Bullet2 bullet=new Bullet2(x,y,degree,2,0);
    bulletList2.add(bullet);
  }
  void randomShot(){
    degree=random(0,360);
    Bullet3 bullet=new Bullet3(x,y,degree,2,0);
    bulletList3.add(bullet);
  }
}