import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:snmobile/activities/preview.dart';
import 'package:snmobile/config.dart';
import 'package:snmobile/components/news_card.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class News extends StatefulWidget {
  final type;
  final code;
  final name;

  News({this.type, this.code, this.name});

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  dynamic _dump = [];
  dynamic _dump1 = [];

  dynamic countryCode = 'NG';
  dynamic newsType = 'Sports';
  dynamic countryName = 'Nigeria';
  bool isFailure = false;
  bool isLoading = true;
  int dumpLength;

  @override
  void initState() {
    countryCode = widget.code;
    newsType = widget.type;
    countryName = widget.name;
    _ftechNews(newsType, countryCode, true);
    super.initState();
    Timer.periodic(Duration(minutes: 10), (timer) {
      _ftechNews(newsType, countryCode, false).then((temp) {
        if (_dump.length != _dump1.length) {
          _showNotification();
        }
       _dump =_dump1;
        setState(() {});
      });

    });
  }

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Smobilev', 'plain body', platformChannelSpecifics,
        payload: 'item x');


  }


  Future _ftechNews(String type, String isoCode, bool isFirst) async {
    http.Client client = new http.Client();
    try {
      var uri =
          '$PROVIDER_URL/top-headlines?country=$isoCode&category=$type&apiKey=$API_KEY';
      print(uri);
      var response = await client.get(Uri.encodeFull(uri));
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body)['articles'];
        print("map  "+ jsonDecode(response.body)['articles'].toString());
        if (isFirst) {
          _dump = data;
        } else {
          _dump1 = data;

        }
        isFailure = false;
        isLoading = false;
        if (isFirst) {
          setState(() {});
        }
      }
    } catch (ex) {
      setState(() {
        isFailure = true;
        isLoading = false;
      });
      throw Exception(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? Center(
              child: SpinKitRing(
              color: backgroundColor,
              size: 40.0,
            ))
          : isFailure
              ? Center(
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 3),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.warning, color: backgroundColor, size: 50),
                          Text(FAILURE),
                        ],
                      )))
              : _dump == '' ||
                      _dump == null ||
                      _dump == 'null' ||
                      _dump.length == 0
                  ? Center(
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 3),
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.face,
                                  color: backgroundColor, size: 50),
                              Text(
                                  '$newsType News not Availble in $countryName'),
                            ],
                          )))
                  : ListView.builder(
                      padding: EdgeInsets.only(top: 15.0, bottom: 16.0),
                      itemBuilder: (BuildContext context, int index) {
                        return NewsCard(post: _dump[index]);
                      },
                      itemCount: _dump.length,
                    ),
    );
  }
}
