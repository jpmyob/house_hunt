import 'package:path_provider/path_provider.dart';
import 'package:real_state_finder/screens/favourite-list-screen.dart';
import 'package:real_state_finder/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveDatabaseService {
  initDatabase() async {
    var appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
    fvBox = Hive.openBox('HH_favoriteList');
    recentBox = Hive.openBox('HH_recentBox');
  }

  addFavoriteProperty(property) {
    fvBox = Hive.box('HH_favoriteList');
    List fvList = fvBox.get('fv_list', defaultValue: []);
    var check = fvList.any((el) => el['address'] == property['address']);
    if(!check) {
      fvList.add(property);
      fvBox.put('fv_list', fvList);
    }
  }

  deletefavoriteProperty(property, context) {
    fvBox = Hive.box('HH_favoriteList');
    List fvList = fvBox.get('fv_list', defaultValue: []);
    List list = fvList.where((el) => el['address'] != property['address']).toList();
    fvBox.put('fv_list', list);
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteListScreen(favoriteList: list)));
  }

  addRecentProperty(List list) async {
    recentBox = Hive.box('HH_recentBox');
    List recentList = await recentBox.get('recent_list', defaultValue: []);
    for(var property in list) {
      var check = recentList.any((el) => el['address'] == property['address']);
      if(!check) {
        recentList.insert(0, property);
      }
    }
    if(recentList.length > 100) recentList = recentList.sublist(0, 100);
    await recentBox.put('recent_list', recentList);
  }
}