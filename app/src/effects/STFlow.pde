// 文字が流れるエフェクトクラス
class STFlow
{
  ArrayList<Sentence> stList;
  final int TS_INIT_Y;
  
  STFlow()
  {
    stList = new ArrayList<Sentence>();
    TS_INIT_Y = height - FLOW_TEXT_SIZE - int(yRatio * 10);
  }
  
  void add(String _str)
  {
    stList.add(new Sentence(_str, TS_INIT_Y));
  }
  
  void update()
  {
    for(int i=0; i<stList.size(); i++)
    {
      stList.get(i).update();
      if(!stList.get(i).enable())
      {
        stList.remove(i);
      }
    }
  }
  
  void display()
  {
    textAlign(LEFT, TOP);
    textSize(FLOW_TEXT_SIZE);
    
    for(Sentence st : stList)
    {
      st.display();
    }
  }
}


// 流れる文字オブジェクト
class Sentence
{
  PVector pos;
  PVector vel;
  String str;
  boolean effected;
  static final int DEAD_POS_X = -1000;
  static final float FLOW_SPEED = 9.0;
  
  Sentence(String _str, float _initY)
  {
    pos = new PVector();
    vel = new PVector();
    init(_str, _initY);
  }
  
  void init(String _str, float _initY)
  {
    str = _str;
    pos.set(width, _initY);
    vel.set(-FLOW_SPEED, 0.0);
    effected = false;
  }
  
  void update()
  {
    pos.add(vel);
  }
  
  void display()
  {
    text(str, pos.x, pos.y);
  }
  
  boolean enable()
  {
    return DEAD_POS_X <= pos.x;
  }
}
