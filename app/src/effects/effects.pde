// CCC 6th 1A
//
// Author: Kuyuri Iroha, Toshiya
//

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import java.util.Queue;
import java.util.ArrayDeque;


// File loader
BufferedReader reader;
Queue<String> stQueue;

// Audio
Minim minim;
AudioPlayer sePlayer;

// Effects
int FLOW_TEXT_SIZE = 18;
int EFFECT_NAME_JP = 48;
int EFFECT_NAME_EN = 20;
int TIME_TEXT_SIZE = 100;
color bgColor = color(250, 243, 245);
color textColor = color(#0f0f0f);
float xRatio;
float yRatio;
float minRatio;
PFont font;
PFont timeFont;
ArrayList<Effect> effects;
Snow[] snows = new Snow[10000];
STFlow stFlow;

//マッチング用文字列
final String[] MATCH_STR = new String[]{
  "(雨|あめ|アメ)",
  "(雪|ゆき|ユキ)",
  "(時間|何時|じかん|なんじ)"
};


void scalingSizes()
{
  FLOW_TEXT_SIZE = int(minRatio * FLOW_TEXT_SIZE);
  EFFECT_NAME_JP = int(minRatio * EFFECT_NAME_JP);
  EFFECT_NAME_EN = int(minRatio * EFFECT_NAME_EN);
  TIME_TEXT_SIZE = int(minRatio * TIME_TEXT_SIZE);
}

void setDefFont()
{
  textFont(font);
  fill(textColor);
}

void setup()
{
//  fullScreen();
  size(900, 800);
  xRatio = float(width) / 800;
  yRatio = float(height) / 500;
  minRatio = min(xRatio, yRatio);
  scalingSizes();
  
  // File reader
  reader = createReader("ts");
  stQueue = new ArrayDeque<String>();
  
  // Audio
  minim = new Minim(this);
  sePlayer = minim.loadFile("SE1.mp3");
  sePlayer.setGain(-20.0);

  // Font
  font = createFont("NotoSansCJKjp-hinted/NotoSansCJKjp-Light.otf", minRatio * 48, true);
  timeFont = createFont("futura", minRatio * 48, true);
  
  // Objects
  effects = new ArrayList<Effect>();
  stFlow = new STFlow();
}


void draw()
{
  // reading file.
  if(frameCount % 60 == 0)
  {
    String str = null;
    try
    {
      str = reader.readLine();
    }
    catch(IOException e)
    {
      e.printStackTrace();
      println("Error occured on read file.");
    }
    
    if(str != null && !str.isEmpty())
    {
      stFlow.add(str);
      println(str);
    }
  }
  
  background(bgColor);
  
  // Effects
  updateEffects();
  setDefFont();
  for(Effect effect : effects)
  {
    effect.update();
    effect.display();
    effect.displayWord(width/2, height/2);
  }
  
  
  // STFlow
  setDefFont();
  stFlow.update();
  stFlow.display();
}


// エフェクトのセット
void updateEffects()
{
  // エフェクトの追加
  if(effects.isEmpty())
  {
    int matchedCount = 0;
    for(Sentence st : stFlow.stList)
    {
      for(int i=0; i<MATCH_STR.length; i++)
      {
        if(isMatch(st.str, MATCH_STR[i]) && !st.effected)
        {
          switch(i)
          {
            // 雨
            case 0:
            effects.add(new Rain());
            break;
            
            // 雪
            case 1:
            effects.add(new Snow());
            break;
            
            // 現在時刻
            case 2:
            effects.add(new WhatsTime(timeFont));
            break;
            
            default:
            println("ERROR: "+st.str+" is not set a process.");
            break;
          }
          matchedCount++;
          st.effected = true; //<>//
          sePlayer.play(); //<>//
          sePlayer.rewind();
        }
      }
      // ループから抜ける
      if(matchedCount != 0) {break;}
    }
  }
  // エフェクトの削除
  else if(effects.get(0).finished())
  {
    effects.remove(0);
  }
}


// 文字列のマッチング
boolean isMatch(String _str, String _matchStr)
{
  return match(_str, _matchStr) != null;
}


// 終了処理
void stop()
{
  sePlayer.close();
  minim.stop();
  super.stop();
}
