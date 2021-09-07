import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_state_finder/utils/constants.dart';

class ReadService {
  final FlutterTts tts = new FlutterTts();
  bool read = true; 

  initFlutterTTS() async {
    tts.setLanguage("en");
    tts.setSpeechRate(0.5);
    await tts.speak(' ');
  }

  readAloud(List data) async {
    if(data.length > 0 && read && 
    Geolocator.distanceBetween(initialPos.latitude, initialPos.longitude, currentPos.latitude, currentPos.longitude) >= coveredDistance) {
      read = false;
      double add = searchRadius > 500 ? searchRadius/2 : searchRadius;
      coveredDistance = coveredDistance + add;
      String text = '${data.length} real state property found!';
      for(var item in data) {
        text = text+ '${item['statusText']}!.'+item['address']+'.\n'+'${item['beds'] ?? 0} Beds,'+
        '${item['baths']?.toInt() ?? 0} Baths,'+'Area: '+'${item['area'] ?? 0} square feets.'+
        'Price'+ item['price']+'.\n';
      }
      await tts.speak(text);
      tts.setCompletionHandler(() => read = true);
    }
  }
}