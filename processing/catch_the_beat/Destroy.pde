class Destroy
{
  GameController parent_;
  
  Destroy(GameController parent)
  {
    parent_ = parent;
  }
  
  void initialize()
  {
    saveScore();
    parent_.isDead_ = true;
    parent_.beatModerator_.speed_ = 0.1;
    parent_.beatModerator_.rotationAngle_ = 0.005;
  }
  
  void update()
  {
    parent_.player_.rotateRadius_ += 0.005;
    parent_.player_.transparent_ -= 5;
    parent_.beatModerator_.transparent_ -= 5;
    parent_.status_.enableDisplay_ = false;
    
    if(parent_.player_.transparent_ <= -300)
    {
      parent_.parent_.sceneSequence_ = SceneSequence.next_result;
    }
  }
  
  void saveScore()
  {
    String[] data = new String[resourceLoader.score_.length+1];
    if(parent_.score_ > resourceLoader.highScore_)
    {
      parent_.isNewRecord_ = true;
    }
    boolean isAdded = false;
    for(int i=0; i<resourceLoader.score_.length; ++i)
    {
      if((parent_.score_ > resourceLoader.score_[i] 
        || i == resourceLoader.score_.length-1 )
        && !isAdded
      ){
        data[i] = String.valueOf(parent_.score_);
        parent_.rank_ = i+1;
        isAdded = true;
      }
      data[i+(isAdded?1:0)] = String.valueOf(resourceLoader.score_[i]);
    }
    saveStrings("data/score.txt", data);
  }
}