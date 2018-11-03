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
final color BG_COL_DEF = color(250, 243, 245);
final color BG_COL_BLACK = color(15);
color bgColor = BG_COL_DEF;
final color TX_COL_DEF = color(15);
final color TX_COL_WHITE = color(250);
color textColor = TX_COL_WHITE;
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
  "^(?=.*(雨|あめ|アメ))(?!.*大).*",
  "(雪|ゆき|ユキ)",
  "(時間|何時|じかん|なんじ)",
  "(ジャガイモ|じゃがいも|馬鈴薯|馬鈴薯)",
  "(ネギ|ねぎ|葱)",
  "(シイタケ|しいたけ|椎茸)",
  "(ニンジン|にんじん|人参)",
  "(トマト|とまと)",
  "(キュウリ|きゅうり|胡瓜)",
  "(ダイコン|だいこん|大根)",
  "(猫|ねこ|ネコ)",
  "(犬|いぬ|イヌ)",
  "(牛|うし|ウシ)",
  "(虎|とら|トラ)",
  "(鼠|ねずみ|ネズミ)",
  "(兎|うさぎ|ウサギ)",
  "(竜|龍|りゅう|リュウ|ドラゴン|タツ)",
  "(蛇|へび|ヘビ)",
  "(馬|うま|ウマ|午)",
  "(羊|ひつじ|ヒツジ)",
  "(猿|さる|サル)",
  "(鶏|にわとり|ニワトリ)",
  "(猪|いのしし|イノシシ)",
  "(文学部|ぶんがくぶ|ブンガクブ)",
  "(総合数理学部|そうごうすうりがくぶ|ソウゴウスウリガクブ)",
  "(アルパカ|あるぱか)",
  "(シマリス|しまりす)",
  "(ジャイアントパンダ|パンダ|ぱんだ|じゃいあんとぱんだ)",
  "(キタキツネ|きたきつね|狐|きつね|キツネ)",
  "(トナカイ|となかい)",
  "(大雨|おおあめ)"
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
  DICTIONARY_DATA.put(
    "猫", 
    "学名 Felis silvestris catus\nネコ（猫）は、狭義には食肉目ネコ科ネコ属に分類されるヨーロッパヤマネコが家畜化されたイエネコに対する通称である。人間によくなつくため、イヌ（犬）と並ぶ代表的なペットとして日本をはじめ世界中で広く飼われている。"
  );
  DICTIONARY_DATA.put(
    "犬", 
    "学名 Canis lupus familiaris\n古く日本ではヤマイヌ（狼）に対して「イエイヌ」とも言っていた。英語名 domestic dog は、伝統的な学名 C. familiaris（家族の-犬）を英訳にしたもので、日本では domestic dog の訳語として古来からのイエイヌの語をあてるようになった。"
  );
  DICTIONARY_DATA.put(
    "牛", 
    "学名 Bos taurus\n一方、やや広義では、ウシ属 Bosを指し、そこにはバンテンなどの野生牛が含まれる。さらに広義では、ウシ亜科 Bovinae の総称となる。すなわち、アフリカスイギュウ属、アジアスイギュウ属、ウシ属、バイソン属などを指す。これらは一般の人々も牛と認めるような共通の体形と特徴を持っている。大きな胴体、短い首と一対の角、胴体と比べて短めの脚、軽快さがなく鈍重な動きである。"
  );
  DICTIONARY_DATA.put(
    "虎", 
    "学名 Panthera tigris\nメスよりもオスの方が大型になる。腹部の皮膚は弛んで襞状になる。背面は黄色や黄褐色で、黒い横縞が入る。縞模様は藪などでは周囲に溶けこみ輪郭を不明瞭にし、獲物に気付かれずに忍び寄ったり待ち伏せることに適している。腹面や四肢内側は白い。黒化個体の発見例はないが、インドでは白化個体の発見例がある。"
  );
  DICTIONARY_DATA.put(
    "鼠", 
    "学名 Microtus arvalis\nネズミのほとんどが夜行性である。また、ネズミの門歯は一生伸び続けるというげっ歯類の特徴を持っているため、常に何か硬いものを（必ずしも食物としてではなく）かじって前歯をすり減らす習性がある。硬いものをかじらないまま放置しておくと、伸びた前歯が口をふさぐ形になり食べ物が口に入らなくなってしまい餓死してしまう。"
  );
  DICTIONARY_DATA.put(
    "兎", 
    "学名 Leporinae Trouessart\n全身が柔らかい体毛で覆われている小型獣である。最大種はヤブノウサギで体長 50–76 cm。毛色は品種改良もあって色も長さも多彩である。多くの種の体毛の色彩は、背面は褐色・灰色・黒・白・茶色・赤茶色・ぶち模様などで、腹面は淡褐色や白である。"
  );
  DICTIONARY_DATA.put(
    "竜", 
    "学名 ---\n竜（りゅう、りょう、たつ、龍）は、神話・伝説の生きもの。英語の dragon（や他の西洋諸語におけるこれに相当する単語）の訳語として「竜」が用いられるように、巨大な爬虫類を思わせる伝説上の生物を広く指す場合もある。"
  );
  DICTIONARY_DATA.put(
    "蛇", 
    "学名 Serpentes Linnaeus\n俗に顎を外して獲物を飲み込むとされるが、実際には方形骨を介した顎の関節が2つあり、開口角度を大きく取ることができる。さらに下顎は左右2つの独立した骨で形成され、靭帯で繋がっている。上顎骨や翼状骨も頭骨に固定されておらず、必要に応じて前後に動かすことができる。歯も喉奥に向かって反り返り、これらにより獲物を咥えながら顎を動かすことにより獲物を少しずつ奥に呑みこむことができる。"
  );
  DICTIONARY_DATA.put(
    "馬", 
    "学名 Equus caballus\n社会性の強い動物で、野生のものも家畜も群れをなす傾向がある。北アメリカ大陸原産とされるが、北米の野生種は、数千年前に絶滅している。欧州南東部にいたターパンが家畜化したという説もある。"
  );
  DICTIONARY_DATA.put(
    "羊", 
    "学名 Ovis aries\nヒツジは反芻動物としては比較的体は小さく、側頭部のらせん形の角と、羊毛と呼ばれる縮れた毛をもつ。\n原始的な品種では、短い尾など、野生種の特徴を残すものもある。"
  );
  DICTIONARY_DATA.put(
    "猿", 
    "学名 Macaca fuscata\n体毛は寒冷地では長く密に被われ、温暖地では短く薄く被われる傾向がある。背面の毛衣は赤褐色や褐色、腹面の毛衣は灰色。種小名fuscataは「暗色がかった」の意。顔や尻は裸出し赤い。幼獣は体毛が密に被われるが、成長に伴い密度は低くなる。オスは犬歯が発達する。"
  );
  DICTIONARY_DATA.put(
    "鶏", 
    "学名 Gallus gallus domesticus\n頭部に「鶏冠（とさか）」とあごの部分には「肉垂（英語版）（にくすい）、もしくは肉髯（にくぜん）」と呼ばれる皮膚が発達した装飾器官がある。雌よりも雄の方が大きい。目の後ろには耳があり耳たぶのことを「耳朶（じだ）」と呼ぶ。"
  );
  DICTIONARY_DATA.put(
    "猪", 
    "学名 Sus scrofa Linnaeus\n非常に突進力が強く、ねぐらなどに不用意に接近した人間を襲うケースも多い。イノシシの成獣は70kgかそれ以上の体重がある上、時速45kmで走る事も可能であり、イノシシの全力の突撃を受けると、大人でも跳ね飛ばされて大けがを負う危険がある。"
  );
  DICTIONARY_DATA.put(
    "文学部", 
    "過去から現在まで多様に展開されてきた人間の営みのすべてに対して、さまざまな角度からの考察を試みながら、究極的には、生きた人間そのものを総合的に理解することを目的として構成されている学部（明治大学公式サイトより）"
  );
  DICTIONARY_DATA.put(
    "総合数理学部", 
    "現象数理学科、先端メディアサイエンス学科、ネットワークデザイン学科で構成される学部\n数理科学と情報技術の最先端を学び、あらゆる現象を解明するチカラと、新たなモデルを創造・発信するチカラを身につける学部"
  );
  DICTIONARY_DATA.put(
    "アルパカ", 
    "学名:Lama glama pacos \n偶蹄目ラクダ科。体長は約1m。主にチリ、ペルーなど南アメリカ北西部で育養されている。ビクーニャを原種としており、その毛は品質・量ともに優れ衣類として使われることも多くある。"
  );
  DICTIONARY_DATA.put(
    "シマリス", 
    "学名:Tamias sibiricus\nげっ歯目リス科。体長は12〜23cmほどで、その尻尾の長さは9〜13cmにもなる。主に北海道、シベリア、朝鮮半島などの山岳・森林でみられる。秋になると、貯蔵用の植物であるドングリなどの木の実を頬袋に詰め、地下の冬眠用の巣に運ぶ。"
  );
  DICTIONARY_DATA.put(
    "ジャイアントパンダ", 
    "学名:Ailuropoda melanoleuca\n食肉目裂脚亜目パンダ科。体長は120〜150cmほどで、体重は100〜150kgにも及ぶ。主に中国中西部の山岳の竹林に生息している。動作の一つ一つがおっとりとしており冬眠はしない。タケ、タケノコ、ササを主食としており1日のうち14時間近くを食事に費やしている。繁殖が難しく絶滅が危惧されている。"
  );
  DICTIONARY_DATA.put(
    "キタキツネ", 
    "学名:Vulpes vulpes schrencki\n食肉目裂脚亜目イヌ科。アカギツネの亜種である。主に北海道に生息し、峠の休息所などによく姿をあらわす。親ギツネは命がけで子育てをするが、子別れの時には容赦なく追い出す。"
  );
  DICTIONARY_DATA.put(
    "トナカイ", 
    "学名:Rangifer tarandus \n偶蹄目シカ科。体長は1.2〜2.2mほどである。シカ類では唯一、角がオスとメスともにある。群れで生活をし、数万頭の大群で季節移動を行う。暖かい季節は草や小動物を食べ、寒い冬はハナゴケ類などの地衣類を食べる。"
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
  fill(textColor);
  textFont(font);
}

void setDefColor()
{
  bgColor = BG_COL_DEF;
  textColor = TX_COL_DEF;
}

void setBlackColor()
{
  bgColor = BG_COL_BLACK;
  textColor = TX_COL_WHITE;
}

void setup()
{
//  fullScreen();
  size(1000, 850);
  frameRate(30);
  xRatio = float(width) / 800;
  yRatio = float(height) / 500;
  minRatio = min(xRatio, yRatio);
  scalingSizes();
  
  // File reader
  reader = createReader("ts");
  stQueue = new ArrayDeque<String>();
  
  // Recording
  rec = new Recording("../dest/request.rq");
  
  // Audio
  minim = new Minim(this);
  sePlayer = minim.loadFile("SE1.mp3");
  sePlayer.setGain(-20.0);

  // Font
  font = createFont("NotoSansCJKjp-Bold.otf", minRatio * 48, true);
  timeFont = createFont("futura", minRatio * 48, true);

  // 辞書用データの作成
  CreateDictionaryData();
  
  // Objects
  effects = new ArrayList<Effect>();
  stFlow = new STFlow();
  ripple = new Ripple();
  
  setDefColor();
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
  fill(textColor);

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
          setDefColor();
          switch(i)
          {
            // 雨
            case 0:
            effects.add(new Rain());
            break;
            
            // 雪
            case 1:
            setBlackColor();
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
            
            // 猫
            case 10:
            effects.add(new Dictionary("猫", DICTIONARY_DATA.get("猫")));
            break;
            
            // 犬
            case 11:
            effects.add(new Dictionary("犬", DICTIONARY_DATA.get("犬")));
            break;
            
            // 牛
            case 12:
            effects.add(new Dictionary("牛", DICTIONARY_DATA.get("牛")));
            break;
            
            // 虎
            case 13:
            effects.add(new Dictionary("虎", DICTIONARY_DATA.get("虎")));
            break;
            
            // 鼠
            case 14:
            effects.add(new Dictionary("鼠", DICTIONARY_DATA.get("鼠")));
            break;
            
            // 兎
            case 15:
            effects.add(new Dictionary("兎", DICTIONARY_DATA.get("兎")));
            break;
            
            // 竜
            case 16:
            effects.add(new Dictionary("竜", DICTIONARY_DATA.get("竜")));
            break;
            
            // 蛇
            case 17:
            effects.add(new Dictionary("蛇", DICTIONARY_DATA.get("蛇")));
            break;
            
            // 馬
            case 18:
            effects.add(new Dictionary("馬", DICTIONARY_DATA.get("馬")));
            break;
            
            // 羊
            case 19:
            effects.add(new Dictionary("羊", DICTIONARY_DATA.get("羊")));
            break;
            
            // 猿
            case 20:
            effects.add(new Dictionary("猿", DICTIONARY_DATA.get("猿")));
            break;
            
            // 鶏
            case 21:
            effects.add(new Dictionary("鶏", DICTIONARY_DATA.get("鶏")));
            break;
            
            // 猪
            case 22:
            effects.add(new Dictionary("猪", DICTIONARY_DATA.get("猪")));
            break;
            
            // 文学部
            case 23:
            effects.add(new Dictionary("文学部", DICTIONARY_DATA.get("文学部")));
            break;
            
            // 総合数理学部
            case 24:
            effects.add(new Dictionary("総合数理学部", DICTIONARY_DATA.get("総合数理学部")));
            break;
            
            // アルパカ
            case 25:
            effects.add(new Dictionary("アルパカ", DICTIONARY_DATA.get("アルパカ")));
            break;
            
            // シマリス
            case 26:
            effects.add(new Dictionary("シマリス", DICTIONARY_DATA.get("シマリス")));
            break;
            
            // ジャイアントパンダ
            case 27:
            effects.add(new Dictionary("ジャイアントパンダ", DICTIONARY_DATA.get("ジャイアントパンダ")));
            break;
            
            // キタキツネ
            case 28:
            effects.add(new Dictionary("キタキツネ", DICTIONARY_DATA.get("キタキツネ")));
            break;
            
            // トナカイ
            case 29:
            effects.add(new Dictionary("トナカイ", DICTIONARY_DATA.get("トナカイ")));
            break;
            
            // 大雨
            case 30:
            effects.add(new HeavyRain());
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