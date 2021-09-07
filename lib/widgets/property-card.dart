import 'package:flutter/material.dart';

class PropertyCard extends StatelessWidget {
  final item;
  PropertyCard({@required this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}