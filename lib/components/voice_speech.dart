import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:snmobile/config.dart';

Future<http.Response> getVoice(String text) async{

  String url='https://texttospeech.googleapis.com/v1beta1/text:synthesize?key=$VOICEAPI_KEY';
  var body={
      "audioConfig": {
        "audioEncoding": "LINEAR16",
        "pitch": 0,
        "speakingRate": 1
      },
      "input": {
        "text": "$text"
      },
      "voice": {
        "languageCode": "en-US",
        "name": "en-US-Wavenet-D"
      }
    };

    var response = http.post(
      url,
      headers:{"Content-Type":"application/json"},
      body: json.encode(body)
    );

  return response;
}