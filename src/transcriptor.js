/**
 * Google Speech API 実行　コードファイル
 * Auther: Kuyuri Iroha
 */


'use strict';
// 環境変数ロード
const dotenv = require('dotenv');
dotenv.config();

const fs = require('fs');
let chokidar = require('chokidar');

// Imports the Google Cloud client library
const speech = require('@google-cloud/speech');

// Creates a client
const client = new speech.SpeechClient();


let appendResult = (data)=> {
  fs.appendFile('effects/data/ts', `${data}\n`, 'utf-8', (er)=> {if(er) {throw er;}});
}

let notifyEndedRecord = ()=> {
  fs.writeFile('dest/request', 'ENDED', 'utf-8', (er)=> {if(er) {throw er;}});
}

let watcher = chokidar.watch('dest/voice.raw', {
  ignored: /[\/\\]\./,
  persistent: true
});

watcher.on('ready', function() { 
  console.log("Start watcing the voice file");
});

const encoding = 'LINEAR16';
const sampleRateHertz = 16000;
const languageCode = 'ja-JP';
watcher.on('change', function(path) {
  let stats = fs.statSync(path);
  let fileSizeInBytes = stats["size"];
  if (0 < fileSizeInBytes)
  {
    console.log(`Changed the voice file -> ${path}`);
    notifyEndedRecord();
    let audioByte = fs.readFileSync(path).toString('base64');
    let audio = {
        content: audioByte
    };
    let request = {
        audio: audio,
        config: {
            encoding: encoding,
            sampleRateHertz: sampleRateHertz,
            languageCode: languageCode,
        },
        interimResults: false,
    }


    client
      .recognize(request)
      .then(data => {
        const response = data[0];
        const transcription = response.results
          .map(result => result.alternatives[0].transcript)
          .join('\n');
        console.log(`Transcription: ${transcription}`);
        appendResult(transcription);
      })
      .catch(err => {
        console.error('ERROR:', err);
      });
  }
});