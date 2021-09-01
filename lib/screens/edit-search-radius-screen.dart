import 'package:flutter/material.dart';
import 'package:real_state_finder/utils/constants.dart';

class EditSearchRadiusScreen extends StatefulWidget {
  @override
  _EditSearchRadiusScreenState createState() => _EditSearchRadiusScreenState();
}

class _EditSearchRadiusScreenState extends State<EditSearchRadiusScreen> {
  double sliderValue = searchRadius;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        leadingWidth: 50.0,
        titleSpacing: 0.0,
        title: Text(
          'Change Search Area Radius', 
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$sliderValue metres', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
          Slider(
            value: sliderValue, 
            min: 300,
            max: 2500,
            onChanged: (value) {
              setState(() {
                sliderValue = value.roundToDouble();
              });
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
              ),
              onPressed: () {
                searchRadius = sliderValue;
                Navigator.pop(context);
              }, 
              child: Text('Apply', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }
}