// 時間表示
class WhatsTime extends Effect
{
  PFont font;
  
  WhatsTime(PFont _font)
  {
    super();
    init(_font);
  }
  
  void init(PFont _font)
  {
    super.init();
    font = _font;
  }
  
  String getTimeString()
  {
    int m = minute();
    int h = hour();
    return new String(h + ":" + nf(m, 2));
  }

  void displayWord(float _x, float _y)
  {
    int m = minute();
    int h = hour();
    String time;
    boolean isAM;
    if(12 < h)
    {
      isAM = false;
      time = (h - (h - 12)) + ":" + nf(m, 2);
    }
    else
    {
      isAM = true;
      time = h + ":" + nf(m, 2);
    }
    textFont(font);
    textAlign(CENTER, CENTER);
    textSize(TIME_TEXT_SIZE);
    text(time, _x, _y);
    textSize(TIME_TEXT_SIZE / 4);
    text(isAM ? "AM" : "PM", _x, _y - TIME_TEXT_SIZE/2);
  }

  void update()
  {
  }

  void display()
  {
  }
}
