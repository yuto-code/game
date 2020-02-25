class GameController extends AbstractScene
{
  final int LEVEL_UP_LINE_1 = 200;
  final int LEVEL_UP_LINE_2 = 400;
  final int LEVEL_UP_LINE_3 = 650;
  final int LEVEL_UP_LINE_4 = 900;
  final int LEVEL_UP_LINE_5 = 1250;
  
  int currentLevel_;
  boolean isDead_;
  
  boolean enableDisplaySpeedUp_;
  int countDisplaySpeedUp_;
  
  SceneController parent_;
  Player player_;
  BeatModerator beatModerator_;
  Status status_;
  ReceiveChecker receiveChecker_;
  Destroy destroy_;
  
  GameController(SceneController parent)
  {
    parent_= parent;
    initialize();
  }
  
  void initialize()
  {
    currentLevel_ = 0;
    score_ = 0;
    rank_ = 0;
    isNewRecord_ = false;
    isDead_ = false;
    enableDisplaySpeedUp_ = false;
    countDisplaySpeedUp_ = 60;
    player_ = new Player(this);
    beatModerator_ = new BeatModerator(this);
    status_ = new Status(this);
    receiveChecker_ = new ReceiveChecker(this);
    destroy_ = new Destroy(this);
  }
  
  void update()
  {
    player_.update();
    beatModerator_.update();
    status_.update();
    receiveChecker_.update();
    if(isDead_) destroy_.update();
    
    player_.render();
    beatModerator_.render();
    status_.render();
    if(enableDisplaySpeedUp_) displayFaster();
    
    render();
  }
  
  void speedUpIfNeeded()
  {
    if( (score_ >= LEVEL_UP_LINE_1 && currentLevel_ < 1)
      || (score_ >= LEVEL_UP_LINE_2 && currentLevel_ < 2)
      || (score_ >= LEVEL_UP_LINE_3 && currentLevel_ < 3)
      || (score_ >= LEVEL_UP_LINE_4 && currentLevel_ < 4)
      || (score_ >= LEVEL_UP_LINE_5 && currentLevel_ < 5)
    ) {
      ++currentLevel_;
      //beatModerator_.speed_ += 0.15;
      beatModerator_.speed_ += 0.3;
      enableDisplaySpeedUp_ = true;
    }
  }
  
  void subtractHP(int sub)
  {
    player_.hp_ -= sub;
    if(player_.hp_ < 0)
    {
      destroy_.initialize();
    }
    status_.setSubtractX(sub);
  }
  
  void render()
  {
    
  }
  
  void displayFaster()
  {
    --countDisplaySpeedUp_;
    if(countDisplaySpeedUp_ <= 0)
    {
      enableDisplaySpeedUp_ = false;
      countDisplaySpeedUp_ = 60;
    }
    else
    {
      if(countDisplaySpeedUp_%6 < 3) text("speed up!", width/2, height*2/5);
    }
  }
}