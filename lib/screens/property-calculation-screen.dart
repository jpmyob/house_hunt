import 'package:flutter/material.dart';
import 'package:real_state_finder/utils/constants.dart';
import 'package:real_state_finder/widgets/number-text-field.dart';

class PropertyCalcScreen extends StatefulWidget {
  final property;
  PropertyCalcScreen({@required this.property});
  @override
  _PropertyCalcScreenState createState() => _PropertyCalcScreenState();
}

class _PropertyCalcScreenState extends State<PropertyCalcScreen> {
  final downController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        titleSpacing: 0,
        title: Text(
          'Nearby Properties', 
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Max Price', style: propertyCalcLabel,),
                  Text(widget.property['price'], style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Down Payment(%)', style: propertyCalcLabel,),
                  NumberTextField(controller: downController, width: 50.0,),
                  Text('${double.parse(widget.property['price']) * double.parse(downController.text) / 100}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Interest(%)', style: propertyCalcLabel,),
                  NumberTextField(controller: downController, width: 50.0,),
                  NumberTextField(controller: downController, width: 50.0,),
                  Text('${double.parse(widget.property['price']) * double.parse(downController.text) / 100}', style: propertyCalcValue,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}