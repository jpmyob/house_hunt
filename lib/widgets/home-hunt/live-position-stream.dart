import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_state_finder/widgets/home-hunt/change-search-radius.dart';
import 'package:real_state_finder/widgets/home-hunt/property-list.dart';

class LivePositionStream extends StatelessWidget {
  final Position position;
  final List propertyList;
  LivePositionStream({@required this.position, @required this.propertyList});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Position>(
      stream: Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high, 
      forceAndroidLocationManager: true),
      initialData: position,
      builder: (BuildContext context, AsyncSnapshot snapshot){
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