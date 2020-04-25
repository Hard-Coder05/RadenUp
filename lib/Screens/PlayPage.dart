import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CoinsPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class PlayPage extends StatefulWidget {
  @override
  _PlayPageState createState() => _PlayPageState();
}
class _PlayPageState extends State<PlayPage> {
  final String url = "http://3.6.119.41:5000/quiz/questions/";
  List data;
  int _points=0;
  int _level=0;
  Future navigateToCoinsPage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CoinsPage()));
  }
  @override
  initState()  {
    super.initState();
    this.getJsonData();
    _loadCounter();
  }
  Future<String> getJsonData() async{
    var response = await http.get(
      Uri.encodeFull(url),
      headers: {"Accept": "application/json"}
    );
    setState(() {
      var convertDataToJson=json.decode(response.body);
      data = convertDataToJson['results'];
    });
  }
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = (prefs.getInt('points') ?? 400);
      _level = (prefs.getInt('levels') ?? 1);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Level: "'$_level'.toString(),style: TextStyle(fontSize: 40.0,color: Colors.red),),
          leading: GestureDetector(
            onTap: () { Navigator.pop(context); },
            child: Icon(
              Icons.arrow_back_ios,  // add custom icons also
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {Navigator.pop(context);},
                  child: Icon(Icons.monetization_on,color: Colors.amber,size: 40.0,),
                )
            ),
            Padding(
                padding: EdgeInsets.only(right: 20.0,top: 15.0),
                child: GestureDetector(
                  onTap: () {navigateToCoinsPage(context);},
                  child: Text('$_points'.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
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
                                Image.network(
                                  data[_level-1]['options'][0]['image'],height: 180,width: 180,fit: BoxFit.fill,
                                ),
                                Image.network(
                                  data[_level-1]['options'][1]['image'],height: 180,width: 180,fit: BoxFit.fill,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.network(
                                  data[_level-1]['options'][2]['image'],height: 180,width: 180,fit: BoxFit.fill,
                                ),
                                Image.network(
                                  data[_level-1]['options'][3]['image'],height: 180,width: 180,fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}
