import 'dart:math';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Home.dart';
import 'WaitingScreen.dart';
class PlayPage extends StatefulWidget {
  @override
  _PlayPageState createState() => _PlayPageState();
}
class _PlayPageState extends State<PlayPage> {
  final String url = "http://3.6.119.41:5000/quiz/questions/";
  List data;
  int _points=0;
  int _level=0;
  String _answer=" ";
  List answerOptions;
  String s="";
  String answer="";
  var isLoading = false;
  @override
  initState()  {
    super.initState();
    _loadCounter();
    _fetchData();
  }

  //fetches data from the API and converts it to JSON
  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.get(
        Uri.encodeFull(url),
        headers: {"Accept": "application/json"}
    );
    if (response!=null) {
      setState(() {
        var convertDataToJson=json.decode(response.body);
        data = convertDataToJson['results'];
        answer=data[_level-1]['answer'];
        isLoading=false;
      });
    } else {
      throw Exception('Failed to load questions');
    }
  }

  //loads the data(level and coins) stored in the shared preferences
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = (prefs.getInt('points') ?? 400);
      _level = (prefs.getInt('levels') ?? 1);
    });
  }

  //widget
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
            appBar: AppBar(
              title: Text("Level: "'$_level'.toString(),style: TextStyle(fontSize: 40.0,color: Colors.red),),
              leading: GestureDetector(
                onTap: () { _onBackPressed(); },
                child: Icon(
                  Icons.arrow_back_ios,  // add custom icons also
                ),
              ),
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Icon(Icons.monetization_on,color: Colors.amber,size: 40.0,),
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(right: 20.0,top: 15.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text('$_points'.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                    )
                ),
              ],
            ),
            body: isLoading
                ? WaitingScreen()
            : Stack(
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
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(top:20.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.network(
                                      data[_level-1]['options'][0]['image'],height: 160,width: 160,fit: BoxFit.fill,
                                    ),
                                    Image.network(
                                      data[_level-1]['options'][1]['image'],height: 160,width: 160,fit: BoxFit.fill,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.network(
                                      data[_level-1]['options'][2]['image'],height: 160,width: 160,fit: BoxFit.fill,
                                    ),
                                    Image.network(
                                      data[_level-1]['options'][3]['image'],height: 160,width: 160,fit: BoxFit.fill,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                ),
                                SizedBox(
                                  height: 40.0,
                                  width: 250.0,
                                  child: new RaisedButton(
                                    elevation: 50.0,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(12.0)),
                                    color: Colors.lightGreen,
                                    child: new Text("Your Answer",
                                        style: new TextStyle(fontSize: 30.0, color: Colors.white)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                ),
                                showAnsweredOptions(),
                                 Padding(
                                   padding: const EdgeInsets.only(top: 30.0),
                                 ),
                                SizedBox(
                                  height: 40.0,
                                  width: 250.0,
                                  child: new RaisedButton(
                                    elevation: 50.0,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(12.0)),
                                    color: Colors.lightGreen,
                                    child: new Text("Given Letters",
                                        style: new TextStyle(fontSize: 30.0, color: Colors.white)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                ),
                                 showAnswerOptions(),
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
          ),
    );
  }

  // to add answer into answered variable
  addToAnswered(String asdf) {
    _answer=_answer+asdf;
    answer=answer.replaceFirst(new RegExp(asdf), '');
    showAnswerOptions();
    showAnsweredOptions();
    if(answer.isEmpty){
      verify();
    }
  }

  // To remove letters from Answered and adding it back into given option
  removeFromAnswered(String asdf) {
    answer=answer+asdf;
    _answer=_answer.replaceFirst(new RegExp(asdf), '');
    showAnswerOptions();
    showAnsweredOptions();
  }

  //
  Widget showAnswerOptions(){
    return GridView.count(
        primary: false,
        crossAxisCount: 10,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(2.0),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 5.0,
        shrinkWrap: true,
        children: (answer.split('')).map((String urla) {
          return GridTile(
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      addToAnswered(urla);
                    });
                  },
                  child: Container( height:25.0,width:25.0,color:Colors.red,child: Text(urla,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0),)))
          );
        }).toList());
  }

  //
  Widget showAnsweredOptions(){
    return GridView.count(
        primary: false,
        crossAxisCount: 10,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        shrinkWrap: true,
        children: (_answer.trim().split('')).map((String urla) {
          return GridTile(
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      removeFromAnswered(urla);
                    });
                  },
                  child: Container(height:25.0,width:25.0,color:Colors.green,child: Text(urla,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0),)))
          );
        }).toList());
  }

    //verifies whether the answer is correct or not
  verify(){
    String x=data[_level-1]['answer'];
 if(equalsIgnoreCase(x.trim(),_answer.trim())){
   _incrementCounter();
   CorrectAnswer();
 }
 else{
   wrongAnswer();
 }
  }

  // increments the level and score if the answer is correct
  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int counter = (prefs.getInt('counter') ?? 0) + 1;
    setState(() {
     prefs.setInt("points", _points+4);
     prefs.setInt("levels", _level+1);
    });
  }

  // Appears on screen if answer is wrong
  wrongAnswer() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sorry! You gave the wrong Answer!'),
          content: Text('Play Again?'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => Home(),
                ), (e) => false);
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => PlayPage(),
                ), (e) => false);
              },
            )
          ],
        );
      },
    ) ;
  }

  // Appears on screen if user presses back on androis screen
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to exit the Game'),
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
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => Home(),
                ), (e) => false);
              },
            )
          ],
        );
      },
    ) ?? false;
  }

  // Appears if the answer given by the user is correct
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
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => Home(),
                ), (e) => false);
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => PlayPage(),
                ), (e) => false);
              },
            )
          ],
        );
      },
    ) ;
  }

  // to compare two strings irrespective of their cases
  bool equalsIgnoreCase(String a, String b) =>
      (a == null && b == null) ||
          (a != null && b != null && a.toLowerCase() == b.toLowerCase());
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  final FocusNode _answerFocus = FocusNode();
  final answerController = TextEditingController();

  // Shows Answer Input Box
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

  // disposes the super and answer controller
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    answerController.dispose();
    super.dispose();
  }
}
