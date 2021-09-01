import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_state_finder/screens/loading-screen.dart';
import 'package:real_state_finder/utils/constants.dart';
import 'package:real_state_finder/widgets/home-hunt/change-search-radius.dart';
import 'package:real_state_finder/widgets/home-hunt/property-list.dart';

class LivePositionStream extends StatelessWidget {
  final Position position;
  final List propertyList;
  LivePositionStream({@required this.position, @required this.propertyList});

  reloadPropertyData(context, Position pos) {
    double distance =  Geolocator.distanceBetween(initialPos.latitude, initialPos.longitude, pos.latitude, pos.longitude);
    if(distance > 10000) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Position>(
      stream: Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high, 
      forceAndroidLocationManager: true),
      initialData: position,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        reloadPropertyData(context, snapshot.data);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChangeSearchRadius(),
            PropertyList(position: snapshot.data, propertyList: propertyList ?? []),
          ],
        );
      },
    );
  }
}