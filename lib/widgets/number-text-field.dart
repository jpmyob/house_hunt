import 'package:flutter/material.dart';
import 'package:real_state_finder/utils/constants.dart';

class NumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  NumberTextField({@required this.controller, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 100.0,
      height: 30.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        decoration: inputDecoration,
        style: TextStyle(color: Colors.black87),
        keyboardType: TextInputType.number,
        controller: controller,
      ),
    );
  }
}