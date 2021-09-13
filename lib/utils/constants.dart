import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_state_finder/screens/loading-screen.dart';
import 'package:real_state_finder/services/read-text-service.dart';
const ZILLOW_IP = 'https://www.zillow.com/search/GetSearchPageState.htm';

var minPrice = 0, maxPrice = 3000000, isAllHomes = true, isLotLand = true, isCondo = true,
isTownhouse = true, isApartment = true, isManufactured = true, forSale = true;

String zillowFilter = '"price":{"min":$minPrice,"max":$maxPrice},"monthlyPayment":{"min":0},"isAllHomes":{"value":$isAllHomes},"isApartment":{"value":$isApartment},'+
  '"isTownhouse":{"value":$isTownhouse},"isComingSoon":{"value":$isAllHomes},"isNewConstruction":{"value":$isAllHomes},"isManufactured":{"value":$isManufactured},'+
  '"isLotLand":{"value":$isLotLand},"isCondo":{"value":$isCondo},"isApartmentOrCondo":{"value":${isApartment && isCondo}}';

var fvBox;
var recentBox;
List allPropertyList = [];
bool read = true;

reStartApp(context) {
  coveredDistance = 0;
  allPropertyList = [];
  ReadService().tts.stop();
  Navigator.popUntil(context, (route) => route.isFirst);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingScreen()));
    Timer(Duration(seconds: 3), () => read = true);
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

TextStyle propertyCalcLabel = TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);
TextStyle propertyCalcValue = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);

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