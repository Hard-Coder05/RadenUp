import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CoinsPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Home.dart';
class PlayPage extends StatefulWidget {
  @override
  _PlayPageState createState() => _PlayPageState();
}
class _PlayPageState extends State<PlayPage> {
  final String url = "http://3.6.119.41:5000/quiz/questions/";
  List data;
  int _points=0;
  int _level=0;
  String _answer;
  Future navigateToCoinsPage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CoinsPage()));
  }
  @override
  initState()  {
    super.initState();
    _loadCounter();
    this.getJsonData();
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                showAnswerInput(),
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
                                      child: new Text("SUBMIT",
                                          style: new TextStyle(fontSize: 30.0, color: Colors.white)),
                                      onPressed:() {
                                        verify();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            )
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
  verify(){
 final x=data[_level-1]['answer'];
 _answer=answerController.text;
 print(x);
 print(_answer);
 if(equalsIgnoreCase(x,_answer)){
   _incrementCounter();
   CorrectAnswer();
 }
 else{
   return showDialog(context: context,builder: (context){
     return AlertDialog(
       title: Text("Tu chutiya hai"),
     );
   });
 }
  }
  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int counter = (prefs.getInt('counter') ?? 0) + 1;
    setState(() {
     prefs.setInt("points", _points+4);
     prefs.setInt("levels", _level+1);
    });
  }
  CorrectAnswer() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Congratulation! You gave the correct answer!'),
          content: Text('Continue Playing?'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayPage(),
                  ),
                );
              },
            )
          ],
        );
      },
    ) ;
  }
  bool equalsIgnoreCase(String a, String b) =>
      (a == null && b == null) ||
          (a != null && b != null && a.toLowerCase() == b.toLowerCase());
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  final FocusNode _answerFocus = FocusNode();
  final answerController = TextEditingController();
  Widget showAnswerInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
      child: new TextFormField(
        controller: answerController,
        textInputAction: TextInputAction.next,
        validator: (value) => value.isEmpty ? 'Answer can\'t be empty' : null,
        onFieldSubmitted: (term){
          _fieldFocusChange(context, _answerFocus, verify());
        },
        focusNode: _answerFocus,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Answer',
            icon: new Icon(
              Icons.arrow_forward,
              color: Colors.grey,
            )
        ),
        onSaved: (value) => _answer = value.trim(),
      ),
    );
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    answerController.dispose();
    super.dispose();
  }
}
