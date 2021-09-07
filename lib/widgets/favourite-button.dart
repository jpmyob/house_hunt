import 'package:flutter/material.dart';
import 'package:real_state_finder/services/hive-database-service.dart';


class FavouriteButton extends StatefulWidget {
  final property;
  FavouriteButton({@required this.property});
  @override
  _FavouriteButtonState createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  IconData icon = Icons.favorite_outline;
  final hiveService = HiveDatabaseService();
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: Colors.white,), 
      onPressed: () {
        if(icon == Icons.favorite_outline) {
          hiveService.addFavoriteProperty(widget.property);
        }
        setState(() => icon = Icons.favorite);
      },
    );
  }
}