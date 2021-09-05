import 'package:flutter/material.dart';
import 'package:real_state_finder/screens/all-property-list-screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/image/home_hunt.jpg',
                ),
                fit: BoxFit.fill
              ),
            ),
            child: Center(),
          ),
          ListTile(
            leading: Icon(
              Icons.list_alt
            ),
            title: Text('All Property Around 2 miles'),
            onTap: () async {
              Navigator.pop(context);
              await Navigator.push(context, MaterialPageRoute(builder: (context) => AllPropertyListScreen()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.favorite
            ),
            title: Text('Favorite List'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.history
            ),
            title: Text('Recent Property'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}