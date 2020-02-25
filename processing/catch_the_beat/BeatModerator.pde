class BeatModerator
{
  GameController parent_;
  ArrayList<Beat> beats_;
  float rotationAngle_;
  float rotateRadius_, transparent_;
  float speed_;
  
  BeatModerator(GameController parent)
  {
    parent_ = parent;
    initialize();
  }
  
  void initialize(){
    beats_ = new ArrayList<Beat>();
    addBeat();
    rotateRadius_ = 0;
    transparent_ = 255;
    speed_ = 1;
    rotationAngle_= 0.1;
  }
  
  void update()
  {
    for(int i=0; i<beats_.size(); ++i)
    {
      beats_.get(i).update();
    }
    rotateRadius_ += rotationAngle_;
  }
  
  void render()
  {
    tint(#ffffff, transparent_);
    imageMode(CENTER);
    for(int i=0; i<beats_.size(); ++i)
    {
      beats_.get(i).render();
    }
    imageMode(CORNER);
    tint(#ffffff, 255);
  }
  
  void addBeat()
  {
    beats_.add(new Beat(this));
  }
  
  void removeBeat(Beat beat)
  {
    beats_.remove(beat);
  }
}