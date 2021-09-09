import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_state_finder/screens/loading-screen.dart';
import 'package:real_state_finder/services/read-text-service.dart';
const ZILLOW_IP = 'https://www.zillow.com/search/GetSearchPageState.htm';

var minPrice = 0, maxPrice = 3000000, isAllHome = true, isManufactured = true, isLotLand = true,
  isCondo = true, isApartmentOrCondo = true;
String zillowFilter = '"price":{"min":$minPrice,"max":$maxPrice},"monthlyPayment":{"min":0},"isAllHomes":{"value":$isAllHome},'+
    '"isManufactured":{"value":$isManufactured},"isLotLand":{"value":$isLotLand},"isCondo":{"value":$isCondo},"isApartmentOrCondo":{"value":$isApartmentOrCondo}';

var fvBox;
var recentBox;
List allPropertyList = [];

reStartApp(context) {
  ReadService().tts.stop();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingScreen()));
    allPropertyList = [];
    ReadService().read = true;
    coveredDistance = 0;
  });
}

Position initialPos;
Position currentPos;
double coveredDistance = 0;

double searchRadius = 1000;
exploreLatLong(latitude, longitude) {
  double offset = 0.0155;
  double latMax = latitude + offset;
  double latMin = latitude - offset;
  double lngMax = longitude + offset;
  double lngMin = longitude - offset;
  return {'west': lngMin, 'east': lngMax, 'south': latMin, 'north': latMax};
}


InputDecoration inputDecoration = InputDecoration(
  contentPadding:EdgeInsets.only(left: 5.0),
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 0),
    borderRadius: BorderRadius.all(Radius.circular(0.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 0, color: Colors.transparent),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 0, color: Colors.transparent),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 0, color: Colors.transparent),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 0, color: Colors.transparent),
  ),
);