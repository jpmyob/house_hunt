import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_state_finder/screens/Edit-search-radius-screen.dart';
import 'package:real_state_finder/screens/loading-screen.dart';
import 'package:real_state_finder/services/location-service.dart';
import 'package:real_state_finder/services/real-state-service.dart';
import 'package:real_state_finder/utils/constants.dart';

class RealStateScreen extends StatefulWidget {
  final gpsPosition;
  RealStateScreen({@required this.gpsPosition});

  @override
  _RealStateScreenState createState() => _RealStateScreenState();
}

class _RealStateScreenState extends State<RealStateScreen> {
  final FlutterTts tts = FlutterTts();
  final realStateService = RealStateService();
  StreamSubscription<Position> positionStream;
  Location location = Location();

  @override
  void initState() {
    tts.setLanguage("en");
    tts.setSpeechRate(0.4);
    super.initState();
  }

  @override
  void dispose() {
    tts.stop();
    tts?.cancelHandler();
    positionStream?.cancel();
    super.dispose();
  }

  Future getLiveRealStateList(context) async {
    // positionStream =  Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high, 
    //   forceAndroidLocationManager: true).listen((Position position) {
    //   var distance = Geolocator.distanceBetween(widget.gpsPosition['lat'], widget.gpsPosition['long'], position.latitude, position.longitude);
    //   if(distance > 250.0) {
    //     reFetchData(context);
    //   } 
    // });
    return await realStateService.getRealStateList(latitude: widget.gpsPosition['lat'], longitude: widget.gpsPosition['long']);
  }

  readAloud(List data) async {
    if(data.length > 1) {
      String text = '${data.length} real state property found!';
      for(var item in data) {
        text = text+ '${item['statusText']}!.'+item['address']+'.'+item['beds'].toString()+' Beds,'+
        item['baths'].toInt().toString()+' Baths,'+'Area: '+item['area'].toString()+' square feets.\n'+
        'Price'+ item['price']+'.\n';
      }
      await tts.speak(text);
    }
  }

  reFetchData(context) async {
    tts.stop();
    positionStream?.cancel();
    var res = await location.getCurrentLocation().catchError((e) => reStartApp()); 
    if(res == 'failed') reStartApp();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RealStateScreen(gpsPosition: res)));
  }

  reStartApp() {
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
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData) readAloud(snapshot.data);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Nearby Real State found ${snapshot.data?.length ?? 0}', 
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text(
                          'Search Area Radius: $searchRadius feets', 
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: Colors.teal,
                          primary: Colors.white,
                          padding: EdgeInsets.zero,
                          minimumSize: Size(60, 25),
                        ),
                        onPressed: () {
                          tts.stop();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditSearchRadiusScreen()))
                          .then((value) {
                            if(value == 'saved') {
                              offset = realStateService.searchAreaOffset(searchRadius);
                              reFetchData(context);
                            }
                          });
                        }, 
                        child: Text('Change', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
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