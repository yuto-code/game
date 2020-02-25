class Status
{
  final int HP_BAR_LENGTH = width*5/7;
  
  float HPBarX_, subtractHPBarX_;
  float score_, addScore_;
  boolean enableDisplay_;
  
  GameController parent_;
  
  Status(GameController parent)
  {
    parent_ = parent;
    initialize();
  }
  
  void initialize()
  {
    textSize(FONT_SIZE);
    strokeJoin(ROUND);
    strokeWeight(FONT_SIZE);
    HPBarX_ = HP_BAR_LENGTH;
    subtractHPBarX_ = 0;
    enableDisplay_ = true;
  }
  
  void update()
  {
    if(subtractHPBarX_ > 0)
    {
      float sub = subtractHPBarX_/10;
      HPBarX_ -= sub;
      subtractHPBarX_ -= sub;
    }
  }
  
  void setSubtractX(int sub)
  {
    HPBarX_ -= subtractHPBarX_;
    subtractHPBarX_ = sub*HP_BAR_LENGTH/MAX_HP;
  }
  
  void render()
  {
    if(enableDisplay_)
    {
      fill(150);  stroke(150);
      rect(FONT_SIZE, FONT_SIZE, HP_BAR_LENGTH, 0);
      fill(255);  stroke(255);
      rect(FONT_SIZE, FONT_SIZE, HPBarX_, 0);
      text("score", width*8/9, 0);
      text(parent_.score_, width*8/9, FONT_SIZE);
    }
  }
}