import 'package:geolocator/geolocator.dart';

class Location {

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
      Position position = await Geolocator.getCurrentPosition(forceAndroidLocationManager: true, desiredAccuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 5));
      return {'lat': position.latitude, 'long': position.longitude};
    } catch(e) {
      return 'failed';
    }
  }
}