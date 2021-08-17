import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:real_state_finder/utils/constants.dart';

class RealStateService {
  Future getRealStateList({latitude, longitude}) async {
    try {
      var pos = exploreLatLong(latitude, longitude);
      var res = await http.get(Uri.parse(
        '$ZILLOW_IP?searchQueryState={"pagination":{},"mapBounds":{"west":${pos["west"]},"east":${pos["east"]},"south":${pos["south"]},"north":${pos["north"]}},"isMapVisible":true,"filterState":{"price":{"min":0},"monthlyPayment":{"min":0},"isAllHomes":{"value":true},"isManufactured":{"value":false},"isLotLand":{"value":false},"isCondo":{"value":false},"isApartmentOrCondo":{"value":false}},"isListVisible":true,"mapZoom":14}&wants={"cat1":["listResults","mapResults"],"cat2":["total"]}&requestId=8'
      ));
      return json.decode(res.body)['cat1']['searchResults']['listResults'];
    } on FormatException catch(_) {
      print('caught format exception!');
    }
  }
}