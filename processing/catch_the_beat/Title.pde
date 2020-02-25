class Title extends AbstractScene
{
  int highScore_;
  int count_;
  boolean enableSubtractCount_;
  
  SceneController parent_;
  
  Title(SceneController parent)
  {
    parent_ = parent;
    initialize();
  }
  
  void initialize()
  {
    score_ = 0;
    rank_ = 0;
    isNewRecord_ = false;
    highScore_ = resourceLoader.highScore_;
    count_ = 60;
    enableSubtractCount_ = false;
  }
  
  void update()
  {
    if((keyPressed && key == ' ') || enableSubtractCount_)
    {
      enableSubtractCount_ = true;
      --count_;
      if(count_ <= 0)
      {
        parent_.sceneSequence_ = SceneSequence.next_game;
      }
    }
    
    render();
  }
  
  void render()
  {
    fill(255);  textSize(80);
    text("Catch the Beat", width/2, height*1/3);
    textSize(32);
    text("High score", width/2, height/16);
    text(highScore_, width/2, height/16+FONT_SIZE);
    if(count_%6 < 3)
    {
      fill(#3884D0);  textSize(FONT_SIZE);
      text("PUSH SPACE KEY", width/2,height*3/4);
    }
  }
}