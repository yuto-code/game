class Player{
  //defaults
  float x=width/2;
  float y=height-10;
  int hitPoint=100;
  int maxHP=hitPoint;
  float nowHP;
  boolean isEffected=false;
  boolean isEffected2=false;
  boolean isEffected3=false;
  boolean isEffected4=false;
  boolean isEffected5=false;
  boolean keyEffected=false;
  boolean playerEffect=false;
  
  void draw(){
    if(playerHit){
      if(frameCount%2==0)
        image(playerImg,x,y,40,40);
    }
    else
      image(playerImg,x,y,40,40);
    colorMode(RGB);
    if(frameCount%25==0) laserShot();
    
    nowHP=(float)hitPoint/(float)maxHP;
    if(hitPoint<=20)
      fill(255,0,0);
    else if(hitPoint<=50)
      fill(255,255,0);
    else
      fill(0,255,0);
    rect(780,10,nowHP*200,30);
    fill(0,0,0);
    rect(780+nowHP*200,10,(1-nowHP)*200,30);
    
    if(isEffected && isEffected2 && isEffected3 && isEffected4 && isEffected5){
      if(hitPoint>=70) hitPoint=100;
      else hitPoint+=(int)(maxHP-hitPoint)/5*4;
      isEffected5=false;
    }
    else if(isEffected5){
      if(hitPoint<=70) hitPoint+=30;
      else hitPoint=100;
      isEffected5=false;
    }
    
    if(hitPoint<0) hitPoint=0;
    
    //draw laser
    fill(0,250,154); //mediumSpringGreen
    for(int i=laserList.size()-1;i>=0;i--){
      Laser laser=laserList.get(i);
      if(!finishFlag2)
        laser.move();
      laser.draw();
      for(int j=enemyList.size()-1;j>=0;j--){
        Enemy1 enemy=enemyList.get(j);
        if(collision(enemy.x,enemy.y,40,40,laser.x,laser.y,laser.w,laser.h) && !finishFlag2){
          laser.hit=true;
          if(isEffected3)
            enemy.hitPoint-=15;
          else
            enemy.hitPoint-=10;
          eCount++;
          audio2.play();
          audio2.rewind();
        }
        if(collision(enemy.x,enemy.y,50,50,this.x,this.y,40,40))
          if(frameCount%30==0 && !isEffected2 && !playerHit){
            hitPoint-=5;
            audio9.play();
            audio9.rewind();
            playerHit=true;
          }
      }
      for(int j=enemyList2.size()-1;j>=0;j--){
        Enemy2 enemy=enemyList2.get(j);
        if(collision(enemy.x,enemy.y,40,40,laser.x,laser.y,laser.w,laser.h) && !finishFlag2){
          laser.hit=true;
          if(isEffected3)
            enemy.hitPoint-=15;
          else
            enemy.hitPoint-=10;
          eCount++;
          audio2.play();
          audio2.rewind();
        }
        if(collision(enemy.x,enemy.y,50,50,this.x,this.y,40,40))
          if(frameCount%30==0 && !isEffected2 && !playerHit){
            hitPoint-=5;
            audio9.play();
            audio9.rewind();
            playerHit=true;
          }
      }
      for(int j=enemyList3.size()-1;j>=0;j--){
        Enemy3 enemy=enemyList3.get(j);
        if(collision(enemy.x,enemy.y,40,40,laser.x,laser.y,laser.w,laser.h) && !finishFlag2){
          laser.hit=true;
         if(isEffected3)
            enemy.hitPoint-=15;
          else
            enemy.hitPoint-=10;
          eCount++;
          audio2.play();
          audio2.rewind();
        }
        if(collision(enemy.x,enemy.y,50,50,this.x,this.y,40,40))
          if(frameCount%30==0 && !isEffected2 && !playerHit){
            hitPoint-=5;
            audio9.play();
            audio9.rewind();
            playerHit=true;
          }
      }
      if(collision(boss.x+12.5,boss.y,150,50,laser.x,laser.y,laser.w,laser.h) && apperBoss && !finishFlag2){
          laser.hit=true;
          if(!bossFlag2){
            if(isEffected3)
              boss.hitPoint-=15;
            else
             boss.hitPoint-=10;
            eCount++;  
            audio2.play();
            audio2.rewind();
          }
          if(bossFlag2 && bossHitCount<3)
            bossHitCount++;
          if(bossFlag2 && (bossHitCount==3 || isEffected3)){
            bossFlag2=false;
            bossEffectTime=0;
            bossHitCount=0;
          }
      }
      if(collision(boss.x,boss.y,150,50,this.x,this.y,30,30) && apperBoss){
          if(hitPoint>0 && !playerHit){
            if(frameCount%30==0){
              hitPoint/=2;
              audio9.play();
              audio9.rewind();
              playerHit=true;
            }
          }
      }
      if(laser.needRemove()) laserList.remove(i); //delete laser
      
      if(itemFlag && collision(item.x,item.y,item.w,item.h,this.x,this.y,40,40)){
        iCount++;
        if(keyEffected){
          isEffected=true;
          isEffected2=true;
          isEffected3=true;
          isEffected4=true;
          isEffected5=true;
          musicFlag=true;
          musicTime=5;
          keyEffected=false;
          effectTime=5;
          effectTime2=5;
          effectTime3=5;
          effectTime4=5;
        }
        else{
        switch((int)randomEffect){
          case 1: isEffected=true; break;
          case 2: isEffected2=true; musicFlag=true; musicTime=0; break;
          case 3: isEffected3=true; break;
          case 4: isEffected4=true; break;
          case 5: isEffected5=true; break;
          default: isEffected5=true; break;
        }
        }
        itemFlag=false;
        if(isEffected && isEffected2 && isEffected3 && isEffected4){
          audio3.play();
          audio3.rewind();
        }
        else if(isEffected3 && effectTime3==0){
          audio7.play();
          audio7.rewind();
        }
        else if(isEffected5){
          audio5.play();
          audio5.rewind();
        }
        else{
          audio3.play();
          audio3.rewind();
        }
      }
      
      if(itemFlag2 && collision(item.x2,item.y2,item.w2,item.h2,this.x,this.y,40,40)){
         iCount++;
         if(keyEffected){
          isEffected=true;
          isEffected2=true;
          isEffected3=true;
          isEffected4=true;
          isEffected5=true;
          musicFlag=true;
          musicTime=5;
          keyEffected=false;
          effectTime=5;
          effectTime2=5;
          effectTime3=5;
          effectTime4=5;
        }
        else{
        switch((int)randomEffect2){
          case 1: isEffected=true; break;
          case 2: isEffected2=true; musicFlag=true; musicTime=0; break;
          case 3: isEffected3=true; break;
          case 4: isEffected4=true; break;
          case 5: isEffected5=true; break;
          default: isEffected5=true; break;
        }
        }
        itemFlag2=false;
        if(isEffected && isEffected2 && isEffected3 && isEffected4){
          audio3.play();
          audio3.rewind();
        }
        else if(isEffected3 && effectTime3==0){
          audio7.play();
          audio7.rewind();
        }
        else if(isEffected5){
          audio5.play();
          audio5.rewind();
        }
        else{
          audio3.play();
          audio3.rewind();
        }
      }
      
      if(itemFlag3 && collision(item.x3,item.y3,item.w3,item.h3,this.x,this.y,40,40)){
        iCount++;
        if(keyEffected){
          isEffected=true;
          isEffected2=true;
          isEffected3=true;
          isEffected4=true;
          isEffected5=true;
          musicFlag=true;
          musicTime=5;
          keyEffected=false;
          effectTime=5;
          effectTime2=5;
          effectTime3=5;
          effectTime4=5;
        }
        else{
        switch((int)randomEffect3){
          case 1: isEffected=true; break;
          case 2: isEffected2=true; musicFlag=true; musicTime=0; break;
          case 3: isEffected3=true; break;
          case 4: isEffected4=true; break;
          case 5: isEffected5=true; break;
          default: isEffected5=true; break;
        }
        }
        itemFlag3=false;
        if(isEffected && isEffected2 && isEffected3 && isEffected4){
          audio3.play();
          audio3.rewind();
        }
        else if(isEffected3 && effectTime3==0){
          audio7.play();
          audio7.rewind();
        }
        else if(isEffected5){
          audio5.play();
          audio5.rewind();
        }
        else{
          audio3.play();
          audio3.rewind();
        }
      }
      
      if(keyFlag && collision(item.keyx,item.keyy,item.keyw,item.keyh,this.x,this.y,40,40)){
        kCount++;
        keyEffected=true;
        keyFlag=false;
        audio3.play();
        audio3.rewind();
        keyTime=0;
      }
      
      if(isEffected) playerEffect=true;
      else if(isEffected2) playerEffect=true;
      else if(isEffected3) playerEffect=true;
      else if(isEffected4) playerEffect=true;
      else if(isEffected5) playerEffect=true;
      else playerEffect=false;
    }
  }
  void laserShot(){
    laserList.add(new Laser(x,y,-90,2,20));   //top
    if(isEffected){
      laserList.add(new Laser(x,y,90,2,20));  //bottom
      laserList.add(new Laser(x,y,180,20,2)); //left
      laserList.add(new Laser(x,y,0,20,2));   //right
    }
  }
  
 
  void move(){
    /*
    //cotroller
    if(keyPressed){
      switch(keyCode){
        case UP:   y-=2; break;
        case DOWN: y+=2; break;
        case LEFT: x-=2; break;
        case RIGHT:x+=2; break;
      }
     
    }
    */
    //
    if(deg_x>120){
      deg_x=deg_x-255;
    }
    if(deg_y>120){
      deg_y=deg_y-255;
    }
    if(deg_x<-deg_s){
      x_1=-1;y+=3;
    }else if(deg_x>deg_s){
      x_1=1;y-=3;
    }else{
      x_1=0;
    }
    if(deg_y<-deg_s){
      y_1=-1;x+=3;
    }else if(deg_y>deg_s){
      y_1=1;x-=3;
    }else{
      y_1=0;
    }
    //
    //check triangle in the window?
    if(x-10<0)      x=10;
    if(x+10>width)  x=width-10;
    if(y-10<0)      y=10;
    if(y+10>height) y=height-10;
  }
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