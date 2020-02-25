//Abstract class for scene management
abstract class AbstractScene
{
  int score_;
  int rank_;
  boolean isNewRecord_;
  abstract void update();
}