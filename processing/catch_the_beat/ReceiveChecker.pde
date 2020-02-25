class ReceiveChecker
{
  final int AVAILABLE_SCORE = 10;
  
  GameController parent_;
  Player player_;
  BeatModerator beatModerator_;
  ArrayList<Beat> beats_;
  
  ReceiveChecker(GameController parent)
  {
    parent_ = parent;
    player_ = parent.player_;
    beatModerator_ = parent.beatModerator_;
    beats_ = parent.beatModerator_.beats_;
    initialize();
  }
  
  void initialize()
  {
    
  }
  
  void update()
  {
    for(int i=0; i<beats_.size(); ++i)
    {
      if(beats_.get(i).x_+ beats_.get(i).image.width/2 > player_.x_-player_.RECEIVABLE_RANGE
        && beats_.get(i).x_+ beats_.get(i).image.width/2 < player_.x_+player_.RECEIVABLE_RANGE
        && beats_.get(i).y_+ beats_.get(i).image.height > height-player_.image_.height
        && beats_.get(i).y_+ beats_.get(i).image.height < height-player_.image_.height + 30
      ) {
        parent_.score_ += AVAILABLE_SCORE;
        parent_.speedUpIfNeeded();
        resourceLoader.beatSound_[int(random(0, resourceLoader.BEAT_SOUND_COUNT))].trigger();
        beatModerator_.removeBeat(beats_.get(i));
      }
    }
  }
}