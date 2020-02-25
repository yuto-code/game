enum SceneSequence
  {
    next_title,
    next_game,
    next_result,
    next_none
  }

class SceneController
{
  SceneSequence  sceneSequence_;
  AbstractScene scene_;
  
  SceneController()
  {
    initialize();
  }
  
  void initialize()
  {
    sceneSequence_ = SceneSequence.next_none;
    scene_ = new Title(this);
  }
  
  void update()
  {
    scene_.update();
    switch(sceneSequence_)
    {
    case next_title:
      scene_ = new Title(this);
      sceneSequence_ = SceneSequence.next_none;
      break;
      
    case next_game:
      scene_ = new GameController(this);
      sceneSequence_ = SceneSequence.next_none;
      break;
      
    case next_result:
      scene_ = new  Result(scene_.score_, scene_.rank_, scene_.isNewRecord_, this);
      sceneSequence_ = SceneSequence.next_none;
      break;
      
    case next_none:
      break;
    }
  }
}