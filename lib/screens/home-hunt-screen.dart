import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_state_finder/screens/loading-screen.dart';
import 'package:real_state_finder/services/real-state-service.dart';
import 'package:real_state_finder/widgets/home-hunt/live-position-stream.dart';

class HomeHuntScreen extends StatelessWidget {
  final Position position;
  HomeHuntScreen({@required this.position});

  final realStateService = RealStateService();

  reStartApp(context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingScreen()));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: Text(
          'Nearby Real States', 
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.near_me, color: Colors.white,), 
            onPressed: () {
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: realStateService.getRealStateList(position: position),
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