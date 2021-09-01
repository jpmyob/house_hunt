import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_state_finder/utils/constants.dart';

// ignore: must_be_immutable
class PropertyList extends StatelessWidget {
  final Position position;
  final List propertyList;
  PropertyList({@required this.position, @required this.propertyList}); 

  getListWithInRadius() {
    List list = [];
    for(var pt in propertyList) {
      double distance = Geolocator.distanceBetween(position.latitude, position.longitude, pt['latLong']['latitude'], pt['latLong']['longitude']);
      if(distance <= searchRadius) {
        double angle = Geolocator.bearingBetween(position.latitude, position.longitude, pt['latLong']['latitude'], pt['latLong']['longitude']);
        pt['distance'] = distance.toInt().toString()+'m';
        pt['angle'] = angle.toInt().toString()+'°';
        list.add(pt);
      }
    }
    readAloud(list);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Text(
            'Nearby Property found ${getListWithInRadius()?.length}', 
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        for(var item in getListWithInRadius()) Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Text(item['statusText']+'\n'+item['address']+'\n'+
          'Distance: '+item['distance']+'    Angle: '+item['angle']+'\n'+
          'Beds: '+item['beds'].toString()+',    Baths: '+item['baths'].toInt().toString()+',    Area: '+item['area'].toString()+' sqft\n'+
          'Price'+ item['price']),
        ),
      ],
    );
  }
}