import 'package:flutter/material.dart';
class WaitingScreen extends StatefulWidget {
  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}
class _WaitingScreenState extends State<WaitingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/background.png"),
                fit: BoxFit.fill,),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 120.0,
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/icon.png"),
                          radius: 110.0,
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(top: 60.0),),
                      Text("Please Wait while we load the questions",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),)
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}