class Player
{
  final int RECEIVABLE_RANGE = 240;
  
  int x_, hp_, direction_;
  float rotateRadius_, transparent_;
  
  PImage image_;
  
  GameController parent_;
  
  Player(GameController parent)
  {
    parent_ = parent;
    initialize();
  }
  
  void initialize()
  {
    x_ = width/2;
    hp_ = MAX_HP;
    direction_ = -1;
    rotateRadius_ = 0;
    transparent_ = 255;
    image_ = resourceLoader.playerImage_;
  }
  
  void update()
  {
    int dx=-deg_y/5;
    
    //dx=0;
    //if(keyPressed && keyCode == RIGHT)
    //  dx=20;
    //else if(keyPressed && keyCode == LEFT)
    //  dx=-20;
    
    x_ += dx;
    
    if(x_ < image_.width/2 )
    {
      x_ = image_.width/2;
    }
    else if(x_ > width-image_.width/2)
    {
      x_ = width-image_.width/2;
    }
    
    if(dx < 0) {
      direction_ = -1;
    } else {
      direction_ = 1;
    }
    //x_ = parent_.beatModerator_.beats_.get(0).x_ + 50;
    //x_ = mouseX;
  }
  
  void render()
  {
    if(transparent_ != 255)
    {
      tint(#ffffff, transparent_);
      translate(x_-(image_.width/2), height-image_.height);
      rotate(rotateRadius_);
      image(image_, 0, 0);
      rotate(-rotateRadius_);
      translate(-(x_-(image_.width/2)), -(height-image_.height));
      tint(#ffffff, 255);
    }
    else
    {
      image(image_, x_-(image_.width/2), height-image_.height);
    }
  }  
}