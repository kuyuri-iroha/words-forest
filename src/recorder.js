/**
 * 録音 出力
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

  setTimeout(()=> {
    record.stop();
  }, 5000);
}

let reqFileName = 'dest/request.rq';
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
    else if(-1 < data.indexOf("EndRq"))
    {
      record.stop();
    }
  }
});