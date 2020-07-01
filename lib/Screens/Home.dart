import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:namegame/Services/Connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PlayPage.dart';
import 'package:firebase_admob/firebase_admob.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  int _points=0;
  int _level=0;
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  @override
   initState()  {
    super.initState();
    _loadCounter();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-7309415230190453~2798560443');
    videoAd.load(adUnitId: 'ca-app-pub-7309415230190453/5992017222',targetingInfo: targetingInfo);
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          _incrementCounter();
        });
      }
    };
  }

  // function to add reward to the player if successfully completed the reward video
  RewardedVideoAd videoAd = RewardedVideoAd.instance;
  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int counter = (prefs.getInt('counter') ?? 0) + 1;
    setState(() {
      prefs.setInt("points", _points+50);
      _loadCounter();
    });
  }

  // loads the data (level and score) stored in the shared preferences
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = (prefs.getInt('points') ?? 400);
      _level = (prefs.getInt('levels') ?? 1);
    });
  }

  //routees the user to the play pages
  Future navigateToPlay(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PlayPage()));
  }

  //disposes the banner ad and super
  @override
  void dispose(){
    myBanner.dispose();
    super.dispose();
  }

  // widget
  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-7309415230190453~2798560443').then((response){
    myBanner..load()..show(anchorOffset: 40.0,
      horizontalCenterOffset: 10.0,
      anchorType: AnchorType.bottom,);
    });
    String string;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        string = "0";
        break;
      case ConnectivityResult.mobile:
        string = "1";
        break;
      case ConnectivityResult.wifi:
        string = "2";
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        appBar: AppBar(
          title: Text("Name-Game",style: TextStyle(fontSize: 20.0),),
          leading: GestureDetector(
            onTap: () {},
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
                                Text('$_level'.toString(),style: TextStyle(fontSize: 60.0,color: Colors.red),)
                              ],
                            ),
                               CircleAvatar(
                                backgroundImage: AssetImage("assets/icon.png"),
                                radius: 110.0,
                              ),
                            Padding(padding: const EdgeInsets.only(top:20.0),),
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
                                  onPressed:() {
                                    if(string=="1"||string=="2"){Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlayPage(),
                                      ),
                                    );}
                                    else{
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('You are not connected to any Network Services'),
                                            content: Text('Please check your internet connection and try again'),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Okay'),
                                                onPressed: () {
                                                  Navigator.of(context).pop(false);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
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
            ),
          ],
        ),
      ),
    );
  }

  // appears on screen if user presses the back button
  Future<bool> _onBackPressed() {
    return showDialog(
      barrierDismissible: false,
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

//mobile ad targetting info
MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['games', 'pubg'],
  contentUrl: 'https://flutter.io',
  childDirected: false, // or MobileAdGender.female, MobileAdGender.unknown
  testDevices: <String>["6347E1469C9B0EDCF60ECE5FC693D323"], // Android emulators are considered test devices
);

// initialization of banner ad
BannerAd myBanner = BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: 'ca-app-pub-7309415230190453/6531891512',
  size: AdSize.smartBanner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);