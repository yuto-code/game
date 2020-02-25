class Result extends AbstractScene
{
  int playerCount_;
  
  SceneController parent_;
  
  Result(int score, int rank, boolean isNewRecord, SceneController parent)
  {
    parent_ = parent;
    score_ = score;
    rank_ = rank;
    isNewRecord_ = isNewRecord;
    initialize();
  }
  
  void initialize()
  {
    playerCount_ = resourceLoader.score_.length;
    textSize(FONT_SIZE);
  }
  
  void update()
  {
   render();
  }
  
  void render()
  {
    fill(255);
    textAlign(CENTER);
    text("GAME OVER", width/2, height*1/4);
    
    textAlign(RIGHT);
    text("SCORE", width/2-FONT_SIZE, height/2-FONT_SIZE);
    text("RANKING", width/2-FONT_SIZE, height/2+FONT_SIZE);
    
    textAlign(CENTER);
    text(score_, width*3/5+FONT_SIZE, height/2-FONT_SIZE);
    text(rank_+" / "+playerCount_, width*3/5+FONT_SIZE, height/2+FONT_SIZE);
    if(isNewRecord_)
    {
      fill(#ffff00);
      text("new record!", width/2, height*2/3);
    }
  }
}