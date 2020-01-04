import 'dart:convert' as JSON;
import 'package:flutter/material.dart';
import 'package:snmobile/config.dart' as config;
import 'package:splashscreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snmobile/activities/app.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),
        ),
        home: PrepareApp());
  }
}

class PrepareApp extends StatefulWidget {
  @override
  _PrepareAppState createState() => _PrepareAppState();
}

class _PrepareAppState extends State<PrepareApp> {

  dynamic country='NONE';

  @override
  void initState() {
    config.prepareAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return SplashScreen(
      image: Image.asset('assets/icon/launcher.png'),
      seconds: 10,
      backgroundColor: config.backgroundColor,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.white,
       navigateAfterSeconds: MyApp(country:JSON.jsonEncode({
         "name":'Nigeria', 
         "asset":'assets/flags/ng_flag.png',
          "isoCode":'NG'
         }))
    );
  }
}