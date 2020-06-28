import 'dart:convert' as JSON;
import 'package:flutter/material.dart';
import 'package:snmobile/config.dart' as config;
import 'package:splashscreen/splashscreen.dart';
import 'package:snmobile/activities/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'activities/country_option.dart';

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

  final countryObj = List();
  dynamic country = 'NONE';

  @override
  void initState() {
    config.prepareAppTheme();
    prepareSelectedCountry();
    super.initState();
  }

  prepareSelectedCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedCountry = prefs.getString('country') ?? 'NONE';

    setState(() {
      if (storedCountry != "NONE") {
        country = JSON.jsonDecode(storedCountry);
      } else {
        country = storedCountry;
      }
    });
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
      navigateAfterSeconds:
          country != 'NONE' ? MyApp(country: country) : CountryOption(),
    );
  }
}