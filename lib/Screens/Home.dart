import 'package:flutter/material.dart';

import 'CoinsPage.dart';
import 'Settings.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }
  Future navigateToCoinsPage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CoinsPage()));
  }
  Future navigateToSettings(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        appBar: AppBar(
          title: Text("Name-Game",style: TextStyle(fontSize: 20.0),),
          leading: GestureDetector(
            onTap: () { navigateToSettings(context); },
            child: Icon(
              Icons.settings,  // add custom icons also
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {navigateToCoinsPage(context);},
                  child: Icon(Icons.monetization_on,color: Colors.amber,size: 40.0,),
                )
            ),
            Padding(
                padding: EdgeInsets.only(right: 20.0,top: 15.0),
                child: GestureDetector(
                  onTap: () {navigateToCoinsPage(context);},
                  child: Text("Points",textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                )
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
            ),
          ],
        ),
      ),
    );
  }
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to exit the App'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    ) ?? false;
  }
}
