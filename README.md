# CCC-Festival-2018

総合コンテンツ製作サークル（CCC）にて作成した音声認識型メディアアート。

macOSでのみ動作します。

## 動作環境

1. Node.js がインストール済み
2. [Homebrew](https://brew.sh/index_ja) がインストール済み
3. [SoX](http://sox.sourceforge.net/) を Homebrew にてインストール済み

## インストール方法

### npm install

`git clone`をしてプロジェクトのディレクトリで下記のコマンドを順に実行します。

``` 
$ cd src
$ npm install
```

### リソースの配置

[data.zip](https://drive.google.com/file/d/1xon6xjAOl82MRfs59j3AxXMcNgK-2KXi/view?usp=sharing)を`/src/effects/`へダウンロードして解凍してください。
`/effects`以下のディレクトリ構造が以下のようになっていれば準備完了です。

```
effects
├── Dictionary.pde
├── Effect.pde
├── HeavyRain.pde
├── Rain.pde
├── Recording.pde
├── Ripple.pde
├── STFlow.pde
├── Snow.pde
├── Time.pde
├── data
│   ├── NotoSansCJKjp-Bold.otf
│   ├── SE1.mp3
│   ├── ts
│   └── 波
│       ├── 波_00000.png
│       ~
│       └── 波_00119.png
└── effects.pde
```

### サービスアカウントキーの配置

Google Cloud Platformからサービスアカウントキーを`/src`以下に`app-credentials.json`として配置します。

配置が完了し、起動準備が完了していると、`/src`以下のディレクトリは下記のようになります。

```
src
├── app-credentials.json
├── data
│   ├── request.rq
│   └── voice.raw
├── effects
│   ~
├── node_modules
│   ~
├── package-lock.json
├── package.json
├── recorder.js
└── transcriptor.js
```

## 動作手順

### CUIアプリの起動

1. shellを起動してウィンドウもしくはタブを2つ作ります。
2. `$ cd`コマンドで両方のカレントディレクトリを`/src`へ移動します。
3. 片方のウィンドウに`$ node recorder.js`を入力して、recorderを起動します。
4. もう片方のウィンドウに`$ node transcriptor.js`を入力してtranscriptorを起動します。

「Start watcing ~ file」とそれぞれのウィンドウに表示されればCUIアプリは起動完了です。

アプリの終了は`^C`です。

### Processingアプリの起動

1. `src/effects/effects.pde`をProcessingで開き、実行

### 操作手順

Processingアプリ上でスペースキーを押すことで録音が開始されます。

うまく認識されない時はスペースを押した後少ししてから話し始めるようにすると認識される場合があります。

## LICENSE

[MIT](LICENSE)