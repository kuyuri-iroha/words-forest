// 波紋エフェクト
class Ripple
{
  PImage img[];
  final int LIFE_FRAME = 120;
  int currentFrame;

  Ripple()
  {
    // Load images.
    img = new PImage[LIFE_FRAME];
    for(int i=0; i<LIFE_FRAME; i++)
    {
      img[i] = loadImage("波紋/波紋_"+nf(i, 5)+".png");
    }
		currentFrame = LIFE_FRAME;
  }

  void start()
  {
    currentFrame = 0;
	}

  void update()
	{
    if(frameRate == 60)
    {
      if(frameCount%2 == 0)
      {
        currentFrame++;
      }
    }
    else
  	{
      currentFrame++;
    }

    if(LIFE_FRAME <= currentFrame)
		{
			currentFrame = LIFE_FRAME;
		}
  }

  void display()
  {
		if(currentFrame != LIFE_FRAME)
		{
      imageMode(CENTER);
			image(img[currentFrame], width/2, height/2);
		}
  }
}
