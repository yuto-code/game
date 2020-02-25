class Beat
{
  final int BEAT_TYPE_COUNT = 8;
  final int BASE_SPEED = 10;
  final int INTERVAL = 400;          //interval of beat to beat y
  //final int INTERVAL = 200; 
  final int DIFFERENCE_RANGE = 300;  //difference of beat to beat x
  
  BeatModerator parent_;
   
  int x_, y_;
  boolean addedNext_;
  
  PImage image;
  
  Beat(BeatModerator parent)
  {
    parent_ = parent;
    initialize();
  }
  
  void initialize()
  {
    image = resourceLoader.beatImage_[int(random(0,BEAT_TYPE_COUNT))];
    if(parent_.beats_.size() == 0)
    {
      x_ = int( random(0, width-image.width) );
    }
    else
    {
      //to put beat in screen range
      int range = int(random(-DIFFERENCE_RANGE, DIFFERENCE_RANGE));
      do
      {
        x_ = parent_.beats_.get(parent_.beats_.size()-1).x_+range;
        
        if(x_+image.width > width)
        {
          range = int(random(-DIFFERENCE_RANGE, 0));
        }
        else if(x_ < 0)
        {
          range = int(random(0, DIFFERENCE_RANGE));
        }
      }while(x_+image.width > width || x_ < 0);
    }
    y_ = -image.height;
    addedNext_ = false;
  }
  
  void update()
  {
    y_ += BASE_SPEED * parent_.speed_;
    
    if(y_+image.height >= INTERVAL)
    {
      if(!addedNext_)
      {
        addedNext_ = true;
        parent_.addBeat();
      }
      if(y_+image.height > height)
      {
        parent_.parent_.subtractHP(SOURCE_DAMAGE);
        parent_.removeBeat(this);
      }
    }
  }
  
  void render()
  {
    rotateImage();
  }
  
  void rotateImage()
  {
    int px = x_+image.width/2;
    int py = y_+image.height/2;
    
    translate(px, py);
    rotate(parent_.rotateRadius_);
    image(image, 0, 0);
    rotate(-parent_.rotateRadius_);
    translate(-px, -py); 
  }
}