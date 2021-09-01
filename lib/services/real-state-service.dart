import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:real_state_finder/utils/constants.dart';

class RealStateService {
  Future getRealStateList({Position position}) async {
    try {
      var pos = exploreLatLong(position.latitude, position.longitude);
      var res = await http.get(Uri.parse(
        '$ZILLOW_IP?searchQueryState={"pagination":{},"mapBounds":{"west":${pos["west"]},"east":${pos["east"]},"south":${pos["south"]},"north":${pos["north"]}},"isMapVisible":true,"filterState":{"price":{"min":0},"monthlyPayment":{"min":0},"isAllHomes":{"value":true},"isManufactured":{"value":false},"isLotLand":{"value":false},"isCondo":{"value":false},"isApartmentOrCondo":{"value":false}},"isListVisible":true,"mapZoom":14}&wants={"cat1":["listResults","mapResults"],"cat2":["total"]}&requestId=8'
      ));
      return json.decode(res.body)['cat1']['searchResults']['listResults'];
    } on FormatException catch(e) {
      print('Error: getRealStateList()\n$e');
      return [];
    }
  }

  // double searchAreaOffset(double radius) {
  //   List<double> ara = [600, 60, 0.6];
  //   String res = "0.00";
  //   double offset = 0;
  //   for(int i = 0; i < 3; i++) {
  //     if(radius == 0) break;
  //     if(radius >= ara[i]) {
  //       int division = radius~/ara[i];
  //       radius = radius % ara[i];
  //       if(division > 9) division = 9;
  //       res = res+"$division";
  //     } else {
  //       res = res+"0";
  //     }
  //   }
  //   offset = double.parse(res);
  //   return offset;
  // }
}