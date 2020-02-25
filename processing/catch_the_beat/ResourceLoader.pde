class ResourceLoader
{
  final int BEAT_IMAGE_COUNT = 8;
  final int BEAT_SOUND_COUNT = 9;
  
  int highScore_;
  int[] score_;
  
  PImage playerImage_;
  PImage[] beatImage_;
  
  AudioSample[] beatSound_;
  
  ResourceLoader()
  {
    loadScore();
    loadFontSetting();
    loadPlayerImage();
    loadBeatImage();
    loadBeatSound();
  }
  
  void loadScore()
  {
    String[] data = loadStrings("data/score.txt");
    score_ = int(data);
    highScore_ = int(data[0]);
  }
  
  void loadFontSetting()
  {
    textSize(FONT_SIZE);
    textAlign(CENTER,TOP);
    PFont font = createFont("resource/font/PhantasmAllCaps.ttf", FONT_SIZE);
    textFont(font);
  }
  
  void loadPlayerImage()
  {
    playerImage_ = loadImage("resource/image/player/00.png");
  }
  
  void loadBeatImage()
  {
    beatImage_ = new PImage[BEAT_IMAGE_COUNT];
    for(int i=0; i<beatImage_.length; ++i)
    {
      beatImage_[i] = loadImage("resource/image/beat/"+String.format("%02d",i)+".png");
    }
  }
  
  void loadBeatSound()
  {
    beatSound_ = new AudioSample[BEAT_SOUND_COUNT];
    for(int i=0; i<beatSound_.length; ++i)
    {
      //beatSound_[i] = minim.loadSample("resource/sound/"+String.format("%02d",i)+".wav");
      beatSound_[i] = minim.loadSample("resource/sound/"+String.format("%02d",i)+".mp3");
    }
  }
}