import 'package:flutter/material.dart';
import 'package:real_state_finder/services/read-text-service.dart';
import 'package:wakelock/wakelock.dart';
import 'package:real_state_finder/screens/loading-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ReadService().initFlutterTTS();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: LoadingScreen(),
    );
  }
}