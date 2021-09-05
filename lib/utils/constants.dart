import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:real_state_finder/screens/loading-screen.dart';
const ZILLOW_IP = 'https://www.zillow.com/search/GetSearchPageState.htm';

List allPropertyList = [];

reStartApp(context) {
  allPropertyList = [];
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingScreen()));
  });
}

Position initialPos;
Position currentPos;
double coveredDistance = searchRadius;

double offset = 0.02;
double searchRadius = 1500;
exploreLatLong(latitude, longitude) {
  double latMax = latitude + offset;
  double latMin = latitude - offset;
  double lngMax = longitude + offset;
  double lngMin = longitude - offset;
  return {'west': lngMin, 'east': lngMax, 'south': latMin, 'north': latMax};
}


final FlutterTts tts = new FlutterTts();
bool read = true; 

initFlutterTTS() async {
  tts.setLanguage("en");
  tts.setSpeechRate(0.5);
  await tts.speak(' ');
}

readAloud(List data) async {
  if(data.length > 0 && read && 
  Geolocator.distanceBetween(initialPos.latitude, initialPos.longitude, currentPos.latitude, currentPos.longitude) > coveredDistance) {
    read = false;
    coveredDistance = coveredDistance + searchRadius;
    String text = '${data.length} real state property found!';
    for(var item in data) {
      text = text+ '${item['statusText']}!.'+item['address']+'.\n'+item['beds'].toString()+' Beds,'+
      item['baths'].toInt().toString()+' Baths,'+'Area: '+item['area'].toString()+' square feets.'+
      'Price'+ item['price']+'.\n';
    }
    await tts.speak(text);
    tts.setCompletionHandler(() => read = true);
  }
}