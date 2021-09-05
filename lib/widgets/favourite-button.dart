import 'package:flutter/material.dart';
import 'package:real_state_finder/utils/constants.dart';

class FavouriteButton extends StatefulWidget {
  final property;
  FavouriteButton({@required this.property});
  @override
  _FavouriteButtonState createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  IconData icon = Icons.favorite_outline;
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: Colors.white,), 
      onPressed: () {
        setState(() => icon = Icons.favorite);
        // List fvList = fvBox.get('fv_list', defaultValue: []);
        // print(fvList);
        // fvList.add(widget.property);
      },
    );
  }
}