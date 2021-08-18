import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:real_state_finder/screens/real-state-screen.dart';
import 'package:real_state_finder/services/location-service.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Location location  = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: location.getCurrentLocation(),
        builder: (context, snapshot) {
          if(!snapshot.hasData && !snapshot.hasError) {
            return Center(
              child: SpinKitDoubleBounce(
                color: Colors.teal,
                size: 100.0,
              ),
            );
          }
          if(snapshot.data == 'failed' || snapshot.hasError) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 50.0),
              child: Column(
                children: [
                  Text('Operation Failed!', 
                  style: TextStyle(
                    fontSize: 20.0,
                    height: 1.5,
                    color: Colors.black87),
                  ),
                  SizedBox(height: 20.0,),
                  Text('Either your GPS is turned off or location permission request is denied. Turn on GPS, grant location permission and Restart the app', 
                  style: TextStyle(
                    fontSize: 15.0,
                    height: 1.5,
                    color: Colors.black87),
                  ),
                  SizedBox(height: 30.0),
                  ElevatedButton(
                    child: Text('Restart'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingScreen()));
                    },
                  ),
                ],
              ),
            );
          }
          return RealStateScreen(gpsPosition: snapshot.data,);
        }
      ),
    );
  }
}
