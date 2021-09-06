import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
        if(icon == Icons.favorite_outline) {
          fvBox = Hive.box('HH_favoriteList');
          List fvList = fvBox.get('fv_list', defaultValue: []);
          var check = fvList.any((el) => el['address'] == widget.property['address']);
          if(!check) {
            fvList.add(widget.property);
            fvBox.put('fv_list', fvList);
          }
        }
        setState(() => icon = Icons.favorite);
      },
    );
  }
}