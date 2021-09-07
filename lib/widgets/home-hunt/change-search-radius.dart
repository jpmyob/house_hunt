import 'package:flutter/material.dart';
import 'package:real_state_finder/screens/edit-search-radius-screen.dart';
import 'package:real_state_finder/services/read-text-service.dart';
import 'package:real_state_finder/utils/constants.dart';

class ChangeSearchRadius extends StatelessWidget {
  final readService = ReadService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, top: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Text(
              'Searching Radius: $searchRadius metres', 
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
              readService.tts.stop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditSearchRadiusScreen()));
            }, 
            child: Text('Change', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }
}