// Rain fall
class Rain extends Effect
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
    text("雨", _x, _y);
    textSize(EFFECT_NAME_EN);
    text("[rain]", _x, _y + (yRatio * 50));
  }


  void update()
  {
    pos.add(createParticle());
    pos.add(createParticle());
    pos.add(createParticle());

    for (int i=0; i<pos.size(); i++)
    {
      pos.get(i).y += 5;
      pos.get(i).x += (i%2 == 0) ? 0.01 : -0.01;
    }
  }


  void display()
  {
    stroke(120);
    strokeWeight(1);

    for (int i=0; i<pos.size(); i++)
    {
      if (i%2 == 0)
      {
        line(pos.get(i).x, pos.get(i).y, pos.get(i).x+1.5, pos.get(i).y+25);
      } else
      {
        line(pos.get(i).x, pos.get(i).y, pos.get(i).x-1.5, pos.get(i).y+30);
      }
    }
  }
}
