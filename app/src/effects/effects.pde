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
import java.util.Map;
import java.util.HashMap;
import java.util.Arrays;


// File loader
final int LOAD_FREQ = 120;
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
final int EFFECTS_WORD_OFFSET_Y = 10;
color bgColor = color(250, 243, 245);
color textColor = color(#0f0f0f);
float xRatio;
float yRatio;
float minRatio;
PFont font;
PFont timeFont;
Recording rec;
ArrayList<Effect> effects;
STFlow stFlow;
Ripple ripple;

// マッチング用文字列
final String[] MATCH_STR = new String[] {
  "(雨|あめ|アメ)",
  "(雪|ゆき|ユキ)",
  "(時間|何時|じかん|なんじ)",
  "(ジャガイモ|じゃがいも|馬鈴薯|馬鈴薯)",
  "(ネギ|ねぎ|葱)",
  "(シイタケ|しいたけ|椎茸)",
  "(ニンジン|にんじん|人参)",
  "(トマト|とまと)",
  "(キュウリ|きゅうり|胡瓜)",
  "(ダイコン|だいこん|大根)",
};

// 辞書エフェクト用データ
HashMap<String, String> DICTIONARY_DATA = new HashMap<String, String>();
void CreateDictionaryData()
{
  DICTIONARY_DATA.put(
    "ジャガイモ", 
    "学名 Solanum tuberosum L.\nナス科ナス属の多年草の植物。デンプンが多く蓄えられている地下茎が芋の一種として食用とされる。"
  );
  DICTIONARY_DATA.put(
    "ネギ",
    "学名 Allium fistulosum\n匂いが強いことから「葷」の一つ「禁葷食」ともされる。料理の脇役として扱われることが一般的だが、葉ネギはねぎ焼き、根深ネギはスープなどで主食材としても扱われる。ネギの茎は下にある根から上1cmまでで、そこから上全部は葉になる。よって食材に用いられる白い部分も青い部分も全て葉の部分である。"
  );
  DICTIONARY_DATA.put(
    "シイタケ", 
    "学名：Lentinula edodes\nシイタケは日本、中国、韓国などで食用に栽培されるほか、東南アジアの高山帯や、ニュージーランドにも分布する。日本においては従来から精進料理に欠かせないものであり、食卓に上る機会も多く、また旨み成分がダシともなるため、数あるキノコの中でも知名度、人気ともに高いもののひとつである。英語でもそのままshiitakeで、フランス語ではle shiitake（男性名詞）で受け入れられている。"
  );
  DICTIONARY_DATA.put(
    "ニンジン", 
    "学名Daucus carota subsp\n原産地はアフガニスタン周辺で、大別して西洋系、東洋系の2つの種類がある。代表的な栄養素はカロテンで中サイズの1/2本で1日のビタミンA必要量が取れるほど。"
  );
  DICTIONARY_DATA.put(
    "トマト", 
    "学名 Solanum lycopersicum\nナス科ナス属の植物で、生食でも調理しても多く食べられるトマトはケチャップやトマトソースに使われるため年間消費量は野菜の中で世界一位である。またグルタミン酸の濃度が高くうま味がある。"
  );
  DICTIONARY_DATA.put(
    "キュウリ", 
    "学名 Cucumis sativus L.\nウリ科きゅうり属の植物。きゅうりは95%が水分でできていて、ギネスブックにも世界一カロリーが少ない野菜に登録されており栄養価が低いと思われがちであるが、しっかりと栄養もあり、ダイエットにも効果的な野菜である。"
  );
  DICTIONARY_DATA.put(
    "ダイコン", 
    "学名 Raphanus sativus\nvar. longipinnatus\nアブラナ科ダイコン属の植物。漬物、香辛料などさまざな調理に利用される。また春の七草のすずしろはダイコンの葉のことである。また日本人がもっとも多く食べてる野菜である。"
  );
}


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
  size(1000, 800);
  frameRate(30);
  xRatio = float(width) / 800;
  yRatio = float(height) / 500;
  minRatio = min(xRatio, yRatio);
  scalingSizes();
  
  // File reader
  reader = createReader("ts");
  stQueue = new ArrayDeque<String>();
  
  // Recording
  rec = new Recording("../dest/request");
  
  // Audio
  minim = new Minim(this);
  sePlayer = minim.loadFile("SE1.mp3");
  sePlayer.setGain(-20.0);

  // Font
  font = createFont("NotoSansCJKjp-hinted/NotoSansCJKjp-Bold.otf", minRatio * 48, true);
  timeFont = createFont("futura", minRatio * 48, true);

  // 辞書用データの作成
  CreateDictionaryData();
  
  // Objects
  effects = new ArrayList<Effect>();
  stFlow = new STFlow();
  ripple = new Ripple();
}


void draw()
{
  // reading file.
  if(frameCount % LOAD_FREQ == 0)
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

  // Ripple
  ripple.update();
  ripple.display(width/2, height/2 - yRatio * EFFECTS_WORD_OFFSET_Y);
  
  // Effects
  updateEffects();
  setDefFont();
  for(Effect effect : effects)
  {
    effect.update();
    effect.display();
    effect.displayWord(width/2, height/2 - yRatio * EFFECTS_WORD_OFFSET_Y);
  }
  
  
  // STFlow
  setDefFont();
  stFlow.update();
  stFlow.display();
  
  // 録音状態の処理
  rec.update();
  rec.display();
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

            // ジャガイモ
            case 3:
            effects.add(new Dictionary("ジャガイモ", DICTIONARY_DATA.get("ジャガイモ")));
            break;
            
            // ネギ
            case 4:
            effects.add(new Dictionary("ネギ", DICTIONARY_DATA.get("ネギ")));
            break;
            
            // シイタケ
            case 5:
            effects.add(new Dictionary("シイタケ", DICTIONARY_DATA.get("シイタケ")));
            break;
            
            // ニンジン
            case 6:
            effects.add(new Dictionary("ニンジン", DICTIONARY_DATA.get("ニンジン")));
            break;
            
            // トマト
            case 7:
            effects.add(new Dictionary("トマト", DICTIONARY_DATA.get("トマト")));
            break;
            
            // キュウリ
            case 8:
            effects.add(new Dictionary("キュウリ", DICTIONARY_DATA.get("キュウリ")));
            break;
            
            // ダイコン
            case 9:
            effects.add(new Dictionary("ダイコン", DICTIONARY_DATA.get("ダイコン")));
            break;
            
            default:
            println("ERROR: "+st.str+" is not set a process.");
            break;
          }
          matchedCount++;
          st.effected = true;
          sePlayer.play();
          sePlayer.rewind();
          ripple.start();
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


// キー入力
void keyPressed()
{
  // スペースキーが押されたら録音を開始
  if(key == ' ')
  {
    rec.start();
  }
}
