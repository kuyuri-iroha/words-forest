// 辞書エフェクト
class Dictionary extends Effect
{
  String word;
  String desc;

  Dictionary(String _word, String _desc)
  {
    super();
    word = _word;
    desc = _desc;
  }

  void update()
  {
  }

  void displayWord(float _x, float _y)
  {
    int left = width / 7;
    int nameTop = height / 4;
    textAlign(LEFT, TOP);
    textSize(EFFECT_NAME_JP);
    text(word, left, nameTop);
    textSize(EFFECT_NAME_JP / 2);
    text(desc, left, nameTop + EFFECT_NAME_JP + 60, left * 5, height / 6 * 5);
  }

  void display()
  {
  }
}
