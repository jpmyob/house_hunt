import 'package:flutter/material.dart';
import 'package:real_state_finder/widgets/favourite-button.dart';

class PropertyScreen extends StatelessWidget {
  final property;
  PropertyScreen({@required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        actions: [
          FavouriteButton(property: property),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                property['imgSrc'],
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) => Image.asset('assets/image/home_hunt.jpg'),
              ),
              SizedBox(height: 20.0,),
              Text(property['statusText']+'\n'+property['address'],
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text('Distance: '+property['distance']+'    Angle: '+property['angle']+'\n'+
                'Beds: ${property['beds']?.toInt() ?? 0},    Baths: ${property['baths']?.toInt() ?? 0}'+
                ',    Area: ${property['area'] ?? 0} sqft\n',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text('Price'+ property['price'],
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}