import 'dart:convert' as JSON;
import 'package:flutter/material.dart';
import 'package:snmobile/config.dart' as config;
import 'package:splashscreen/splashscreen.dart';
import 'package:snmobile/activities/app.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isfound=false;

  @override
  void initState() {
    config.prepareAppTheme();
    setCntry();

    super.initState();
  }

  void setCntry() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String found= prefs.getString('isFound');
    if(found!='Yes'){
      await prefs.setString('isFound','Yes');
      isfound=true;
    }else{
      isfound=false;
    }
    
  }
  @override
  Widget build(BuildContext context) {


    if(!isfound){
      Toast.show("Finding your location...",context, gravity:Toast.CENTER , duration: Toast.LENGTH_LONG);
      
      Future.delayed(Duration(milliseconds: 2000), (){
          Toast.show("Nigeria",context, gravity:Toast.CENTER , duration: Toast.LENGTH_LONG);
      });
    }

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