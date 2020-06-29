import 'dart:async';
import 'dart:convert' as JSON;
import 'package:flutter/material.dart';
import 'package:snmobile/components/news.dart';
import 'package:snmobile/config.dart' as config;
import 'package:splashscreen/splashscreen.dart';
import 'package:snmobile/activities/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'activities/country_option.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:rxdart/subjects.dart';

NotificationAppLaunchDetails notificationAppLaunchDetails;
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();


class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();
//notification
  var initializationSettingsAndroid = AndroidInitializationSettings('img_logo');

  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload);
      });

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();


  runApp(App());

}


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