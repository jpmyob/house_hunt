import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_state_finder/screens/property-screen.dart';
import 'package:real_state_finder/utils/constants.dart';

class FavoriteListScreen extends StatelessWidget {
  final List favoriteList;
  FavoriteListScreen({@required this.favoriteList});

  List updatePropertyList() {
    List list = [];
    for(var pt in favoriteList) {
      double distance = Geolocator.distanceBetween(currentPos.latitude, currentPos.longitude, pt['latLong']['latitude'], pt['latLong']['longitude']);
      double angle = Geolocator.bearingBetween(currentPos.latitude, currentPos.longitude, pt['latLong']['latitude'], pt['latLong']['longitude']);
      pt['distance'] = distance.toInt().toString()+'m';
      pt['angle'] = angle.toInt().toString()+'°';
      list.add(pt);
    }
    return list;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        titleSpacing: 0,
        title: Text(
          'Favorite List', 
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                'Total Favorite Property ${favoriteList?.length}', 
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            for(var item in updatePropertyList()) GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyScreen(property: item, showFav: false, showDelete: true,))),
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
        ),
      ),
    );
  }
}