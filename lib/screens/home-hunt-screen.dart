import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_state_finder/services/real-state-service.dart';
import 'package:real_state_finder/utils/constants.dart';
import 'package:real_state_finder/widgets/home-hunt/drawer.dart';
import 'package:real_state_finder/widgets/home-hunt/live-position-stream.dart';

class HomeHuntScreen extends StatelessWidget {
  final Position position;
  HomeHuntScreen({@required this.position});

  final realStateService = RealStateService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        titleSpacing: 0,
        title: Text(
          'Nearby House Properties', 
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.near_me, color: Colors.white,), 
            onPressed: () => reStartApp(context),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: realStateService.getZillowPropertyList(position: position),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return LivePositionStream(position: position, propertyList: snapshot.data,);
            }

            return Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Loading...', 
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}