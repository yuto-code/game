import ddf.minim.*;
//
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
Serial port; 
int inByte;
int deg_x,deg_y;
int deg_s=20;
int x_1,y_1;
//

Minim minim;
//BGM,landing,get item,taken away item,heal,player bomb,power up,apper key,touch boss (music)
AudioPlayer audio,audio2,audio3,audio4,audio5,audio6,audio7,audio8,audio9;
int musicTime=0; //invincible music count
boolean musicFlag=false; //change music flag
int cnt=0; //boss appered text time

//image
PImage backGround4,backGround5;
PImage enhanceIcon1,enhanceIcon2,enhanceIcon3,enhanceIcon4,enhanceIcon5,enhanceIcon6;
PImage tresure,Key,cursor;
PImage enemy1Img,enemy2Img,enemy3Img,bossImg,playerImg;
PImage bullet1,bullet2,bullet3;
PImage Title,GameOver,Clear,ranking,staffList;
PImage ins,ins2,ins3;
int y=-1650;
int inCount=0;

//file
String lines[];
boolean writeFlag=false;
boolean writeFlag2=false;
int count=0;
int eCount=0;
int iCount=0;
int kCount=0;
int dCount=0;


//Arraylist
ArrayList<Bullet1> bulletList1;
ArrayList<Bullet2> bulletList2;
ArrayList<Bullet3> bulletList3;
ArrayList<Laser> laserList;
ArrayList<Enemy1> enemyList;
ArrayList<Enemy2> enemyList2;
ArrayList<Enemy3> enemyList3;

//Boss setting
Boss boss;
boolean apperBoss=false;
boolean bossFlag1=false;
boolean bossFlag2=false;
boolean bossFlag3=false;
int bossEffectTime=0;

//player setting
Player player;
int bossHitCount=0; //invincible penetration count
boolean playerHit=false;

//system setting
int defeatCount=0; //enemy change flag
int time=80;
int state=0;  // 0:Title, 1:Game, 2:Clear, 3:Failurement
int score=0;
boolean finishFlag=false;
boolean finishFlag2=false;

//item setting
Item item;
boolean itemFlag=false;
boolean itemFlag2=false;
boolean itemFlag3=false;
boolean keyFlag=false;
float itemInterval;
float itemInterval2;
float itemInterval3;
float keyInterval;
float keyInterval2;
int effectTime=0;
int effectTime2=0;
int effectTime3=0;
int effectTime4=0;
int keyTime=0;
int rainbow=1;
float randomEffect;
float randomEffect2;
float randomEffect3;

//collision fanction
boolean collision(float x1,float y1,float w1,float h1,float x2,float y2,float w2,float h2){
  if(x1+w1/2<x2-w2/2) return false;
  if(x2+w2/2<x1-w1/2) return false;
  if(y1+h1/2<y2-h2/2) return false;
  if(y2+h2/2<y1-h1/2) return false;
  return true;
}

void setup(){
  //
  println(Serial.list());
  String arduinoPort = Serial.list()[0];
  port = new Serial(this, arduinoPort, 9600);
  //
  size(1000,750); //windowSize
  noStroke(); //delete afterimage
  
  //image used in the game
  backGround4=loadImage("Battle1.jpg");
  backGround5=loadImage("Battle5.jpg");
  enhanceIcon1=loadImage("icon006.png"); //cane
  enhanceIcon2=loadImage("icon010.png"); //shield
  enhanceIcon3=loadImage("icon002.png"); //sword
  enhanceIcon4=loadImage("icon005.png"); //bow
  enhanceIcon5=loadImage("icon014.png"); //gloves
  enhanceIcon6=loadImage("icon013.png"); //shoes
  tresure=loadImage("icon025.png"); //trusure box
  Key=loadImage("icon019.png"); //key
  cursor=loadImage("cursor.png"); //cursor of key
  enemy1Img=loadImage("pipo-enemy038.png");
  enemy2Img=loadImage("pipo-enemy025.png");
  enemy3Img=loadImage("pipo-enemy021.png");
  bossImg=loadImage("pipo-boss001.png");
  playerImg=loadImage("player.png");
  bullet1=loadImage("enemy1bullet.png");
  bullet2=loadImage("enemy2bullet.png");
  bullet3=loadImage("enemy3bullet.png");
  Title=loadImage("Title.PNG");
  GameOver=loadImage("GameOver.PNG");
  Clear=loadImage("Clear.PNG");
  ranking=loadImage("Ranking.PNG");
  staffList=loadImage("StaffList.PNG");
  ins=loadImage("ins1.png");
  ins2=loadImage("ins2.png");
  ins3=loadImage("ins3.png");
  
  //make list
  bulletList1=new ArrayList<Bullet1>(); 
  bulletList2=new ArrayList<Bullet2>();
  bulletList3=new ArrayList<Bullet3>();
  laserList=new ArrayList<Laser>();
  enemyList=new ArrayList<Enemy1>();
  enemyList2=new ArrayList<Enemy2>();
  enemyList3=new ArrayList<Enemy3>();
  player=new Player(); //generate an player
  
  //audio setting
  minim=new Minim(this);
  audio=minim.loadFile("TITLE.mp3");
  audio.play();
  audio2=minim.loadFile("short_bomb.mp3");
  audio3=minim.loadFile("GETITEM.mp3");
  audio4=minim.loadFile("powerdown.mp3");
  audio5=minim.loadFile("RECOVERY.mp3");
  audio6=minim.loadFile("small_explosion1.mp3");
  audio7=minim.loadFile("POWERUP.mp3");
  audio8=minim.loadFile("sword1.mp3");
  audio9=minim.loadFile("STATUSDOWN.mp3");
  
  audio2.setGain(5.0);
  audio3.setGain(5.0);
  audio4.setGain(5.0);
  audio5.setGain(5.0);
  audio6.setGain(5.0);
  audio7.setGain(5.0);
  audio8.setGain(5.0);
  audio9.setGain(5.0);
  
  //file
  textFont(loadFont("data.vlw"));
  lines=loadStrings("data.txt");
}
  
//state machine
void mousePressed(){
  if(state==0 && (mouseX<650 && mouseY<350 && mouseX>350 && mouseY>300)){
    state=1;
    music();
  }
  else if((state==2 || state==3)){
    state=0;
    music();
  }
  else if(state==0 && (mouseX<650 && mouseY<450 && mouseX>350 && mouseY>400))
    state=4;
  else if(state==0 && (mouseX<650 && mouseY<550 && mouseX>350 && mouseY>500))
    state=5;
  else if(state==5 && inCount<3)
    inCount++;
  else if(state==4 || (state==5 && inCount==3))
    state=0; 
  if(state==1 && finishFlag2)
    finishFlag=true;
}

void keyPressed(){
  if(state==0 && key==' '){
    state=1;
    music();
  }
  if(state==1 && key=='q'){
    state=0;
    music();
  }
  if((state==2 || state==3) && keyCode==ENTER){
    state=0;
    music();
  }  
  if(state==0 && key=='r')
    state=4;
  if(state==0 && keyCode==SHIFT)
    state=5;
  if(state==5 && inCount<=3){
    switch(keyCode){
      case RIGHT:inCount++; break;
      case LEFT:inCount--; break;
    }
    if(inCount<0) inCount=0;
    if(inCount>3) inCount=3;
  }
  if((state==4 || state==5) && keyCode==ENTER)
    state=0; 
  if(state==1 && finishFlag2 && keyCode==ENTER)
    finishFlag=true;
}

void stateMachine(){
  if(finishFlag){
  if(state==1  && boss.hitPoint<=0){
    dCount++;
    score=eCount*10+iCount*50+kCount*100+dCount*100;
    score+=time*100;
    score+=player.hitPoint*50;
    state=2;
    music();
  }
  else if(state==1 && (player.hitPoint<=0 || time<=0)){
    score=eCount*10+iCount*50+kCount*100+dCount*100;
    state=3;
    music();
  }
  }
}

//load music file fanction
void music(){
  if(state==0){
    audio.close();
    audio=minim.loadFile("TITLE.mp3");
    audio.play();
    audio.rewind();
  }
  if(state==1 && !finishFlag2){
    if(player.isEffected2){
      audio.close();
      audio=minim.loadFile("INVINCIBLE.mp3");
      audio.play();
      audio.rewind();
    }
    if(!player.isEffected2 && !apperBoss){
      audio.close();
      audio=minim.loadFile("BATTLE3.mp3");
      audio.play();
      audio.rewind();
    }
    if(!player.isEffected2 && apperBoss){
      audio.close();
      audio=minim.loadFile("FINALBATTLE.mp3");
      audio.play();
      audio.rewind();
    }
  }
 if(state==2){
    audio.close();
    audio=minim.loadFile("BATTLEFINISH.mp3");
    audio.play();
    audio.rewind();
  }
  if(state==3){
    audio.close();
    audio=minim.loadFile("GAMEOVER2.mp3");
    audio.play();
    audio.rewind();
   }
}

void draw(){
  stateMachine();
  switch(state) {
    case 1: game();     break;
    case 2: complete(); break;
    case 3: failure();  break;
    case 4: ranking(); break;
    case 5: staffList(); break;
    default:title(); initialization(); break;
  }
}

void ranking(){
  image(ranking,0,0,width,height);
  fill(255,255,0);
  textSize(60);
  text(lines[0],width/2,height/2-30);
  fill(255,255,255);
  textSize(32);
  text("Bonus",width/2,height/2+50);
  text("Time : "+lines[lines.length-2],width/2,height/2+90);
  text("Hit Point : "+lines[lines.length-1],width/2,height/2+130);
  text("All Challenger : "+nf(lines.length-2),width/2,height/2+200);
}

void staffList(){
  switch(inCount){
    case 1:image(ins2,0,0,width,height); break;
    case 2:image(ins3,0,0,width,height); break;
    case 3:image(staffList,0,0,width,height); break;
    default:image(ins,0,0,width,height); break;
  }
}

//default setting
void initialization(){
  //audio setting
  musicTime=0;
  musicFlag=false;
  cnt=0;
  //generate bullet list
  bulletList1=new ArrayList<Bullet1>();
  bulletList2=new ArrayList<Bullet2>();
  bulletList3=new ArrayList<Bullet3>();
  laserList=new ArrayList<Laser>();
  //generate enemy list
  enemyList=new ArrayList<Enemy1>();
  enemyList2=new ArrayList<Enemy2>();
  enemyList3=new ArrayList<Enemy3>();
  //boss setting
  apperBoss=false;
  boss=new Boss((float)(random(300,700)),(float)(random(300,500)),0,100);
  bossFlag1=false;
  bossFlag2=false;
  bossFlag3=false;
  bossEffectTime=0;
  //generate an player
  player=new Player();
  bossHitCount=0;
  //other setting
  time=80;
  score=0;
  //item setting
  item=new Item();
  itemInterval=random(600,1200);
  itemInterval2=random(600,1200);
  itemInterval3=random(600,1200);
  keyInterval=random(1200,2400);
  keyInterval2=0;
  itemFlag=false;
  itemFlag2=false;
  itemFlag3=false;
  keyFlag=false;
  player.isEffected=false;
  player.isEffected2=false;
  player.isEffected3=false;
  player.isEffected4=false;
  player.isEffected5=false;
  player.playerEffect=false;
  effectTime=0;
  effectTime2=0;
  effectTime3=0;
  effectTime4=0;
  keyTime=0;
  randomEffect=5;
  randomEffect2=(int)random(1,6);
  randomEffect3=(int)random(1,6);
  //system default setting
  defeatCount=0;
  finishFlag=false;
  finishFlag2=false;
  //player setting
  playerHit=false;
  playerHit=false;
  
  writeFlag=false;
  writeFlag2=false;
  count=0;
  eCount=0;
  iCount=0;
  kCount=0;
  dCount=0;
  
  inCount=0;
}

//drow title fanction
void title(){
  fill(0,0,0,255); //RGB
  
  // display a title
 imageMode(CORNERS);
 image(Title,0,0,width,height);
 
 //button "start"
 if(mouseX<650 && mouseY<350 && mouseX>350 && mouseY>300){
   fill(127,255,212);
   stroke(127,255,0);
 }
 else{
   fill(0,255,0);
   stroke(34,139,34);
 }
 strokeWeight(5);
 rect(350,300,300,50);
 noStroke();
 textSize(40);
 fill(0,0,0);
 textAlign(CENTER);
 text("START",500,340);
 
 //button "ranking"
 if(mouseX<650 && mouseY<450 && mouseX>350 && mouseY>400){
   fill(250,250,210);
   stroke(255,215,0);
 }
 else{
   fill(255,255,0);
   stroke(255,140,0);
 }
 strokeWeight(5);
 rect(350,400,300,50);
 noStroke();
 textSize(40);
 fill(0,0,0);
 textAlign(CENTER);
 text("HIGH SCORE",500,440);
 
 //button "staff list"
 if(mouseX<650 && mouseY<550 && mouseX>350 && mouseY>500){
   fill(0,255,255);
   stroke(0,0,255);
 }
 else{
   fill(0,0,255);
   stroke(0,0,139);
 }
 strokeWeight(5);
 rect(350,500,300,50);
 noStroke();
 textSize(26);
 fill(0,0,0);
 textAlign(CENTER);
 text("INSTRUCTION & STAFF",500,540);
}

//fanction is concerned at time
void timer(){
  //count down
  if(!finishFlag2){
  if(frameCount%60==0){
    time--;
    //count effect time
    if(player.isEffected) effectTime++;
    if(player.isEffected2) effectTime2++;
    if(player.isEffected3) effectTime3++;
    if(player.isEffected4) effectTime4++;
    if(bossFlag1 || bossFlag2 || bossFlag3) bossEffectTime++;
    if(player.isEffected2)  musicTime++;
    if(apperBoss) cnt++;
    if(keyFlag) keyTime++;
    if(!keyFlag && !player.playerEffect) keyInterval2++;
  }
  if(frameCount%60==0)
    playerHit=false;
  //apper item
  if(frameCount%(int)itemInterval==0 && !itemFlag && !player.playerEffect){
    itemFlag=true;
    itemInterval=random(600,1200);
   do{
      randomEffect=(int)random(1,6);
   }while(randomEffect==randomEffect2 || randomEffect==randomEffect3);
  }
  if(frameCount%(int)itemInterval2==0 && !itemFlag2 && !player.playerEffect){
    itemFlag2=true;
    itemInterval2=random(600,1200);
    do{
      randomEffect2=(int)random(1,6);
    }while(randomEffect==randomEffect2 || randomEffect2==randomEffect3);
  }
  if(frameCount%(int)itemInterval3==0 && !itemFlag3 && !player.playerEffect){
    itemFlag3=true;
    itemInterval3=random(600,1200);
    do{
      randomEffect3=(int)random(1,6);
    }while(randomEffect==randomEffect3 || randomEffect2==randomEffect3);
  }
  if(frameCount%(int)keyInterval==0 && !keyFlag && !player.keyEffected && keyInterval2>=10){
    audio8.play();
    audio8.rewind();
    keyFlag=true;
    keyInterval2=0;
    keyInterval=random(1200,2400);
    keyTime=0;
  }
  if(keyTime>=10){
    keyFlag=false;
    keyTime=0;
  }
  
  //effect time
  if(player.isEffected && effectTime>=10){
    player.isEffected=false;
    effectTime=0;
  }
  if(player.isEffected2 && effectTime2>=10){
    player.isEffected2=false;
    effectTime2=0;
  }
  if(player.isEffected3 && effectTime3>=10){
    player.isEffected3=false;
    effectTime3=0;
  }
  if(player.isEffected4 && effectTime4>=10){
    player.isEffected4=false;
    effectTime4=0;
  }
  if((bossFlag1 || bossFlag2 || bossFlag3) && bossEffectTime>=7){
    bossFlag1=false;
    bossFlag2=false;
    bossFlag3=false;
    bossEffectTime=0;
  }
  }
}
  
//draw shooting fanction
void game(){
  timer();
  
  imageMode(CORNERS);
  if(defeatCount<=3){
  if(y<0){
    image(backGround4,0,y);
    if(frameCount%2==0) y+=1;
    if(y>=0) y=-1650;
  }
  }
  else if(defeatCount==4){
  if(y<0){
    image(backGround5,0,y);
    if(frameCount%2==0) y+=1;
    if(y>=0) y=-1650;
  }
  }
  
  imageMode(CENTER);
  if(player.isEffected)
    image(enhanceIcon1,965,60);
  if(player.isEffected2)
    image(enhanceIcon2,915,60);
  if(player.isEffected3)
    image(enhanceIcon3,890,60);
  if(player.isEffected4)
    image(enhanceIcon4,940,60);
  if(player.keyEffected)
    image(Key,850,60);
  
  fill(0,0,0,70); //RGB
  rect(0,0,width,height); //fills in color of a display
  
  //draw enemy
  for(int i=enemyList.size()-1;i>=0;i--){
      fill(167,87,168); //purple
      Enemy1 enemy=enemyList.get(i);
      if(!finishFlag2)
        enemy.move();
      enemy.draw();
      if(enemy.deleteEnemy()){
        enemyList.remove(i); //delete enemy
        dCount++;
      }
  }
  for(int i=enemyList2.size()-1;i>=0;i--){
      fill(167,87,168); //purple
      Enemy2 enemy=enemyList2.get(i);
      if(!finishFlag2)
        enemy.move();
      enemy.draw();
      if(enemy.deleteEnemy()){
        enemyList2.remove(i); //delete enemy
        dCount++;
      }
  }
  for(int i=enemyList3.size()-1;i>=0;i--){
      fill(167,87,168); //purple
      Enemy3 enemy=enemyList3.get(i);
      if(!finishFlag2)
        enemy.move();
      enemy.draw();
      if(enemy.deleteEnemy()){
        enemyList3.remove(i); //delete enemy
        dCount++;
      }
  }
  //draw boss
  if(apperBoss){
    if(!finishFlag2)
      boss.move();
    boss.draw();
    fill(255,255,255);
    textSize(20);
    textAlign(LEFT);
    text("Boss:"+nf(boss.hitPoint,3),20,30);
    if(bossFlag1)
      image(enhanceIcon6,35,60);
    if(bossFlag2)
      image(enhanceIcon2,60,60);
    if(bossFlag3)
      image(enhanceIcon5,85,60);
  }
  
  //draw player
  if(player.isEffected2){
    colorMode(HSB);
    tint(rainbow,255,255); //if invincible , rainbow
    rainbow=(rainbow+1)%101;
  }
  else
    noTint();
  if(!finishFlag2)
    player.move();
  player.draw();
  noTint();
  
  //draw item
  if((itemFlag || itemFlag2 || itemFlag3 || keyFlag) && !finishFlag2){
    item.move();
    item.draw();
  }
  
   //draw information
  score=eCount*10+iCount*50+kCount*100+dCount*100;
  fill(255,255,255);
  textSize(20);
  textAlign(RIGHT);
  text("Player:"+nf(player.hitPoint,3),980,30);
  fill(255,255,0);
  textSize(30);
  textAlign(CENTER);
  text("Time:"+nf(time,3),500,30);
  text("Score:"+nf(score,4),500,60);
  textAlign(LEFT);
  if(defeatCount<=3) text("Stage:"+nf(defeatCount)+" / 4",20,30);
  
  //first enemy setting
  if(enemyList.size()==0 && enemyList2.size()==0 && enemyList3.size()==0 && defeatCount==0){
    Enemy1 enemy=new Enemy1((float)(random(300,700)),(float)(random(200,400)),0,30);
    enemyList.add(enemy);
    Enemy2 enemy1=new Enemy2((float)(random(100,400)),(float)(random(100,500)),0,30);
    enemyList2.add(enemy1);
    Enemy3 enemy2=new Enemy3((float)(random(100,900)),(float)(random(100,500)),0,30);
    enemyList3.add(enemy2);
    defeatCount++;
    y=-1650;
    playerHit=true;
  }
  //third enemy setting
  if(enemyList.size()==0 && enemyList2.size()==0 && enemyList3.size()==0 && defeatCount==1){
    Enemy1 enemy=new Enemy1((float)(random(300,700)),(float)(random(200,400)),0,30);
    enemyList.add(enemy);
    Enemy2 enemy1=new Enemy2((float)(random(100,400)),(float)(random(100,500)),0,30);
    enemyList2.add(enemy1);
    Enemy2 enemy2=new Enemy2((float)(random(100,400)),(float)(random(100,500)),0,30);
    enemyList2.add(enemy2);
    defeatCount++;
    y=-1650;
    playerHit=true;
  }
  //fourth enemy setting
  if(enemyList.size()==0 && enemyList2.size()==0 && enemyList3.size()==0 && defeatCount==2){
    Enemy2 enemy1=new Enemy2((float)(random(100,400)),(float)(random(100,500)),0,30);
    enemyList2.add(enemy1);
    Enemy3 enemy2=new Enemy3((float)(random(100,400)),(float)(random(100,500)),0,30);
    enemyList3.add(enemy2);
    Enemy3 enemy3=new Enemy3((float)(random(100,400)),(float)(random(100,500)),0,30);
    enemyList3.add(enemy3);
    defeatCount++;
    y=-1650;
    playerHit=true;
  }  
  //final enemy(boss) setting
  if(enemyList.size()==0 && enemyList2.size()==0 && enemyList3.size()==0 && defeatCount==3){
    defeatCount++;
    apperBoss=true;
    musicFlag=true;
    y=-1650;
    playerHit=true;
    if(player.x<500) boss.x=player.x+(float)random(100,500);
    else boss.x=player.x-(float)random(100,500);
    if(player.y<375) boss.y=player.y+(float)random(100,375);
    else boss.y=player.y-(float)random(100,375);
  }
    
  if(apperBoss && cnt<=5){
      fill(255,0,0);
      textSize(32);
      textAlign(CENTER);
      text("BOSS APPERED",width/2,height/4);
    } 
    //change music
    if(musicFlag){
      music();
      musicFlag=false;
    }
    if(musicTime>=10 || effectTime2>=10){
      music();
      musicTime=0;
    }
    
    if(player.hitPoint<=0){
       fill(255,0,0);
       stroke(139,0,0);
       textSize(32);
       textAlign(CENTER);
       text("YOU LOSE!",width/2,height/2);
       noStroke();
       fill(255,255,255);
       text("Press 'ENTER' or Click",width/2,height/2+100);
       finishFlag2=true;
       writeFlag2=true;
    }
    else if(time<=0){
       fill(255,0,0);
       stroke(139,0,0);
       textSize(32);
       textAlign(CENTER);
       text("TIME UP!",width/2,height/2);
       noStroke();
       fill(255,255,255);
       text("Press 'ENTER' or Click",width/2,height/2+100);
       finishFlag2=true;
       writeFlag2=true;
    }
    else if(boss.hitPoint<=0){
       fill(255,255,0);
       stroke(255,255,255);
       textSize(32);
       textAlign(CENTER);
       text("YOU WIN!",width/2,height/2);
       noStroke();
       fill(255,255,255);
       text("Press 'ENTER' or Click",width/2,height/2+100);
       finishFlag2=true;
       apperBoss=false;
       writeFlag2=true;
    }
}

//write high score
void writeFile(){
  String[] temp,temp2;
  temp=new String[lines.length+1];
  temp2=loadStrings("data.txt");
  if(writeFlag2){
  for(int i=0;i<temp.length;i++){
    if(!writeFlag && i<temp.length-2){
      count++;
      if(int(temp2[i])<score){
        temp[i]=String.valueOf(score);
        writeFlag=true;
      }
      else{
        temp[i]=String.valueOf(temp2[i]);
      }
    }
    else{
      temp[i]=String.valueOf(temp2[i-1]);
    }
  }
  if(score==int(temp[0]) && boss.hitPoint<=0){
    temp[temp.length-2]=String.valueOf(time);
    temp[temp.length-1]=String.valueOf(player.hitPoint);
  }
  saveStrings("data.txt",temp);
  writeFlag=false;
  writeFlag2=false;
  lines=loadStrings("data.txt");
  }
}

void drawScore(){
  fill(255,255,255);
  textAlign(CENTER);
  textSize(40);
  text("Total Score:"+nf(score,4),width/2,height/2+80);
  text("Nomal",width/4,height/2+140);
  text("Bonus",width/5*3,height/2+140);
  textAlign(LEFT);
  textSize(26);
  text("Hit Enemy",width/5,height/2+180);
  text(nf(eCount,2)+"×010",width/5+130,height/2+180);
  text("= "+nf(eCount*10,4),width/5+220,height/2+180);
  text("Get Item",width/5*3,height/2+180);
  text(nf(iCount,2)+"×050",width/5*3+130,height/2+180);
  text("= "+nf(iCount*50,4),width/5*3+220,height/2+180);
  text("Get Key",width/5*3,height/2+210);
  text(nf(kCount,2)+"×100",width/5*3+130,height/2+210);
  text("= "+nf(kCount*100,4),width/5*3+220,height/2+210);
  if(boss.hitPoint<=0){
    text("Time",width/5*3,height/2+240);
    text(nf(time,2)+"×100",width/5*3+130,height/2+240);
    text("= "+nf(time*100,4),width/5*3+220,height/2+240);
    text("HP",width/5*3,height/2+270);
    text(nf(player.hitPoint,2)+"×050",width/5*3+130,height/2+270);
    text("= "+nf(player.hitPoint*50,4),width/5*3+220,height/2+270);
  }
  text("Defeat",width/5,height/2+210);
  text(nf(dCount,2)+"×100",width/5+130,height/2+210);
  text("= "+nf(dCount*100,4),width/5+220,height/2+210);
  writeFile();
  textAlign(CENTER);
  textSize(40);
  text("Ranking:     / "+nf(lines.length-2),width/2,height/2+20);
  if(count<10)
    fill(255,255,0);
  text("       "+nf(count),width/2,height/2+20);
  if(count==1) text("New Record!",width/2,height/2-40);
  textSize(26);
  fill(255,255,0);
  text("Press 'ENTER' or Click",width/2,height/2+310);
}

//game clear
void complete(){
  fill(0,0,0,60); //RGB
  imageMode(CORNERS);
  image(Clear,0,0,width,height);
  drawScore();
}

//game over
void failure(){
  fill(0,0,0,60); //RGB
  imageMode(CORNERS);
  image(GameOver,0,0,width,height);
  drawScore();
}