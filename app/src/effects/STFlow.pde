// 文字が流れるエフェクトクラス
class STFlow
{
  ArrayList<Sentence> stList;
  
  STFlow()
  {
    stList = new ArrayList<Sentence>();
  }
  
  void add(String _str)
  {
    float initY;
    while(true)
    {
      initY = random(0.0, height - FLOW_TEXT_SIZE);
      
      for(Sentence st : stList)
      {
        if(st.pos.y < initY && initY < st.pos.y)
        {
          initY = -1;
        }
      }
      
      if(initY != -1)
      {
        break;
      }
    }
    stList.add(new Sentence(_str, initY));
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
    vel.set(random(-3.0, -1.0), 0.0);
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
