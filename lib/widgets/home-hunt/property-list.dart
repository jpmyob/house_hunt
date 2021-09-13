import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_state_finder/screens/property-screen.dart';
import 'package:real_state_finder/services/hive-database-service.dart';
import 'package:real_state_finder/services/read-text-service.dart';
import 'package:real_state_finder/utils/constants.dart';
import 'package:real_state_finder/widgets/property-card.dart';

// ignore: must_be_immutable
class PropertyList extends StatelessWidget {
  final Position position;
  final List propertyList;
  PropertyList({@required this.position, @required this.propertyList}); 

  final hiveService = HiveDatabaseService();
  final readService = ReadService();
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
    
    hiveService.addRecentProperty(list);
    readService.readAloud(list);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Property found ${getListWithInRadius()?.length}', 
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                forSale ? ' (For Sale)' : ' (For Rent)',
              )
            ],
          ),
        ),
        for(var item in getListWithInRadius()) GestureDetector(
          onTap: () {
            readService.tts.stop();
            Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyScreen(property: item)));
          },
          child: PropertyCard(item: item),
        ),
      ],
    );
  }
}