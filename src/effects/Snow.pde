// Snow fall
class Snow extends Effect
{
  ArrayList<PVector> pos;
  
  void init()
  {
    super.init();
    pos = new ArrayList<PVector>();
  }

  PVector createParticle()
  {
    PVector newPos = new PVector();
    newPos.x = random(0, width);
    newPos.y = -40;
    return newPos;
  }


  void displayWord(float _x, float _y)
  {
    textAlign(CENTER, CENTER);
    textSize(EFFECT_NAME_JP);
    text("雪", _x, _y);
    textSize(EFFECT_NAME_EN);
    text("[snow]", _x, _y + (yRatio * 50));
  }


  void update()
  {
    pos.add(createParticle());
    pos.add(createParticle());
    pos.add(createParticle());

    for (int i=0; i<pos.size(); i++)
    {
      if(i%2 == 0)
      {
        pos.get(i).x += random(0.01, 0.15);
      }
      else
      {
        pos.get(i).x -= random(0.01, 0.15);
      }
      
      pos.get(i).y += 3;
    }
  }


  void display()
  {
    fill(250);
    noStroke();
    for (int i=0; i<pos.size(); i++)
    {
      ellipse(pos.get(i).x, pos.get(i).y, 5, 5);
    }
  }
}