import 'package:flutter/material.dart';
import 'Screens/SplashScreen.dart';
void main()=> runApp(new MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      theme: ThemeData(
        primaryColor: Colors.black,
        fontFamily: "Ubuntu",
        brightness: Brightness.dark,
      ),
    );
  }
}
