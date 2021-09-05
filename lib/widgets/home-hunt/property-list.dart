import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_state_finder/screens/property-screen.dart';
import 'package:real_state_finder/utils/constants.dart';

// ignore: must_be_immutable
class PropertyList extends StatelessWidget {
  final Position position;
  final List propertyList;
  PropertyList({@required this.position, @required this.propertyList}); 

  getListWithInRadius() {
    List list = [];
    for(var pt in propertyList) {
      double distance = Geolocator.distanceBetween(position?.latitude, position?.longitude, pt['latLong']['latitude'], pt['latLong']['longitude']);
      if(distance <= searchRadius) {
        double angle = Geolocator.bearingBetween(position?.latitude, position?.longitude, pt['latLong']['latitude'], pt['latLong']['longitude']);
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
        for(var item in getListWithInRadius()) GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyScreen(property: item))),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            padding: EdgeInsets.all(8.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(item['statusText']+'\n'+item['address']+'\n'+
              'Distance: '+item['distance']+'    Angle: '+item['angle']+'\n'+
              'Beds: ${item['beds']?.toInt() ?? 0},    Baths: ${item['baths']?.toInt() ?? 0}'+',    Area: ${item['area'] ?? 0} sqft\n'+
              'Price'+ item['price'],
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}