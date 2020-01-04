import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Color backgroundColor = Colors.red;
double fontSize = 16.0;
const PROVIDER_URL = 'https://newsapi.org/v2';
const API_KEY = '2095f79d474943dabcc9e6c3efed7fb5';
const VOICEAPI_KEY = 'AIzaSyCw4khldtajcc9MYG8RpnMMsSEq5Vl3gw8';
const FAILURE = 'Connection Failed';
const appName = 'SNmobile';
const appTitle = 'SNmobile - News';
const deviceCountry = null;
const country = 'Nigeria';

void getDeviceCountry() async {
  if (deviceCountry == null || country == null) {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        http.Client client = new http.Client();
        String API_KEY = 'H234857hHJSyCw4kdfkta2fgl567pnsodq5Vl38';

        var uri =
            'https://www.googleapis.com/geolocation/v1/geolocate?Key=$API_KEY';
        var response = await client.get(Uri.encodeFull(uri));
        if (response.statusCode == 200) {
          dynamic country = jsonDecode(response.body)['country'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('country', json.encode(country));
        }
      }
    } on SocketException catch (_) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      dynamic storedCountry = prefs.getString('country');
    } catch (ex) {
      throw Exception(ex);
    }
  }
}

void prepareAppTheme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String color = prefs.getString('background');
  if (color != null && color != '') {
    String valueString = color.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    Color currentColor = new Color(value);
    backgroundColor = currentColor;
  }

  double size = prefs.getDouble('fontsize');
  fontSize = size;
}

void subscribe() {
  print('Subscribed');
}
