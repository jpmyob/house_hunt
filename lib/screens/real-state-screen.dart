import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_state_finder/screens/loading-screen.dart';
import 'package:real_state_finder/services/real-state-service.dart';

class RealStateScreen extends StatefulWidget {
  final gpsPosition;
  RealStateScreen({@required this.gpsPosition});

  @override
  _RealStateScreenState createState() => _RealStateScreenState();
}

class _RealStateScreenState extends State<RealStateScreen> {
  final realStateService = RealStateService();
  StreamSubscription<Position> positionStream;

  @override
  void dispose() { 
    positionStream?.cancel();
    super.dispose();
  }

  Future getLiveRealStateList(context) async {
    positionStream =  Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high, 
      forceAndroidLocationManager: true).listen((Position position) {
      var distance = Geolocator.distanceBetween(widget.gpsPosition['lat'], widget.gpsPosition['long'], position.latitude, position.longitude);
      if(distance > 250.0) {
        reFetchData(context);
      }
    });
    return realStateService.getRealStateList(latitude: widget.gpsPosition['lat'], longitude: widget.gpsPosition['long']);
  }

  reFetchData(context) {
    positionStream.cancel();
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
              reFetchData(context);
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getLiveRealStateList(context),
          initialData: [],
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Nearby Real State found ${snapshot.data.length}', 
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0, left: 15.0),
                  child: Text(
                    'Current Position: ${widget.gpsPosition['lat']}, ${widget.gpsPosition['long']}', 
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                for(var item in snapshot.data) Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(item['statusText']+'\n'+item['address']+'\n'+
                  'Beds: '+item['beds'].toString()+',    Baths: '+item['baths'].toString()+',    Area: '+item['area'].toString()+' sqft\n'+
                  'Price'+ item['price']),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}