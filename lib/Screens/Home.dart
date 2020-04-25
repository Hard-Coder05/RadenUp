import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CoinsPage.dart';
import 'PlayPage.dart';
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
  Future navigateToPlay(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PlayPage()));
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
              decoration: BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/background.png"),
                  fit: BoxFit.fill,),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(top:100.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Level:",style: TextStyle(fontSize: 60.0,color: Colors.white),),
                                Text("level",style: TextStyle(fontSize: 60.0,color: Colors.red),)
                              ],
                            ),
                               CircleAvatar(
                                backgroundImage: AssetImage("assets/icon.png"),
                                radius: 110.0,
                              ),
                            Container(
                              decoration: new BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 5.0, // has the effect of softening the shadow
                                    spreadRadius: 2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      1.0, // horizontal, move right 10
                                      1.0, // vertical, move down 10
                                    ),
                                  )
                                ],
                              ),
                              child: SizedBox(
                                height: 60.0,
                                width: 300.0,
                                child: new RaisedButton(
                                  elevation: 50.0,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(12.0)),
                                  color: Colors.lightGreen,
                                  child: new Text("PLAY",
                                      style: new TextStyle(fontSize: 30.0, color: Colors.white)),
                                  onPressed:() {navigateToPlay(context);},
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey,
                                  blurRadius: 5.0, // has the effect of softening the shadow
                                  spreadRadius: 2.0, // has the effect of extending the shadow
                                  offset: Offset(
                                    1.0, // horizontal, move right 10
                                    1.0, // vertical, move down 10
                                  ),
                                )
                              ],
                            ),
                            child: SizedBox(
                              height: 50.0,
                              width: 150.0,
                              child: new RaisedButton(
                                elevation: 50.0,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(12.0)),
                                color: Colors.white,
                                child: new Text("Multiplayer",
                                    style: new TextStyle(fontSize: 20.0, color: Colors.black45)),
                                onPressed:() {navigateToPlay(context);},
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
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