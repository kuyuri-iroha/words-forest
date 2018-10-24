/**
 * 録音 出力　コードファイル
 * Auther: Kuyuri Iroha
 */

let record = require('node-record-lpcm16'),
    fs     = require('fs');

process.stdin.resume();
process.stdin.setEncoding('utf8');
process.stdin.on('data', function(chunk) {
  if(chunk.trim() == "s")
  {
    console.log("start");
    let file = fs.createWriteStream('dest/voice.raw');
    record.start({
      sampleRate : 16000,
      encoding: 'LINEAR16',
      verbose : true
    })
    .pipe(file);
  }
  else if(chunk.trim() == "e")
  {
    console.log("end");
    process.exit(1);
  }
});
process.stdin.on('end', function()
{
  //do something
});