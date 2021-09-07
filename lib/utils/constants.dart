import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_state_finder/screens/loading-screen.dart';
import 'package:real_state_finder/services/read-text-service.dart';
const ZILLOW_IP = 'https://www.zillow.com/search/GetSearchPageState.htm';

var fvBox;
var recentBox;
List allPropertyList = [];

reStartApp(context) {
  allPropertyList = [];
  ReadService().read = true;
  coveredDistance = 0;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingScreen()));
  });
}

Position initialPos;
Position currentPos;
double coveredDistance = 0;

double offset = 0.0155;
double searchRadius = 1000;
exploreLatLong(latitude, longitude) {
  double latMax = latitude + offset;
  double latMin = latitude - offset;
  double lngMax = longitude + offset;
  double lngMin = longitude - offset;
  return {'west': lngMin, 'east': lngMax, 'south': latMin, 'north': latMax};
}