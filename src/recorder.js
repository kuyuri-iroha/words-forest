/**
 * 録音 出力　コードファイル
 * Auther: Kuyuri Iroha
 */

let record = require('node-record-lpcm16'),
    fs     = require('fs'),
    chokidar = require('chokidar');

let recordFunc = ()=> {
  console.log('start');
  let file = fs.createWriteStream('dest/voice.raw');
  record.start({
    sampleRate : 16000,
    encoding: 'LINEAR16',
    verbose : true
  })
  .pipe(file);
}

let reqFileName = 'dest/request';
let reqMS = 'recording';
let watcher = chokidar.watch(reqFileName, {
  ignored: /[\/\\]\./,
  persistent: true
});

watcher.on('ready', function() { 
  console.log('Start watcing ['+ reqFileName +'] file');
});

watcher.on('change', function(path) {
  let stats = fs.statSync(path);
  let fileSizeInBytes = stats['size'];
  if(0 < fileSizeInBytes)
  {
    let data = fs.readFileSync(reqFileName, 'utf-8');
    console.log(`Changed the request file -> ${path}\n${data}`);
    if(-1 < data.indexOf(reqMS))
    {
      recordFunc();
    }
  }
});

process.stdin.resume();
process.stdin.setEncoding('utf8');
process.stdin.on('data', function(chunk) {
  if(chunk.trim() == 's')
  {
    recordFunc();
  }
  else if(chunk.trim() == 'e')
  {
    console.log('end');
    process.exit(1);
  }
});
process.stdin.on('end', function()
{
  //do something
});