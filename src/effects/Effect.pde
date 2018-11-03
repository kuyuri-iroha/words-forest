// エフェクトの抽象クラス
abstract class Effect
{
  final int LIFE_TIME = 15000;
  int startTime;
  int startFrame;
  
  // エフェクトの寿命を決定する関数
  int getLifeTime()
  {
    return LIFE_TIME;
  }
  
  // エフェクトが生成されてからの経過時間
  int getElapsed()
  {
    return millis() - startTime;
  }
  
  // コンストラクタ
  Effect()
  {
    init();
  }
  
  // 初期化関数
  void init()
  {
    startTime = millis();
    startFrame = frameCount;
  }
  
  // エフェクトの終了判定
  boolean finished()
  {
    return getLifeTime() < getElapsed();
  }
  
  // エフェクトが生成されてからの経過フレーム
  int getElapsedFrame()
  {
    return startFrame - frameCount;
  }
  
  
  // 下の3つの関数はオーバーロード必須
  abstract void displayWord(float _x, float _y); // 文字の描画
  abstract void display(); // エフェクトの表示
  abstract void update(); // エフェクトの更新
}