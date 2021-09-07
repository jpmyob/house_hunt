import 'package:geolocator/geolocator.dart';
import 'package:real_state_finder/services/hive-database-service.dart';

class Location {
  final hiveService = HiveDatabaseService();

  Future getCurrentLocation() async {
    try {
      LocationPermission permission;
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
      
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
      } 
      Position position = await Geolocator.getCurrentPosition(forceAndroidLocationManager: true, desiredAccuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 10));
      
      hiveService.initDatabase();
      // var coordinates = new Coordinates(position.latitude, position.longitude);
      // var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      // var first = addresses.first.locality;
      // print("$first");
      return position;
    } catch(e) {
      print(e);
      return 'failed';
    }
  }
}