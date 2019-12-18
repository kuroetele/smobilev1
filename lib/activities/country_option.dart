import 'dart:convert' as JSON;
import 'package:flutter/material.dart';
import 'package:precis/activities/app.dart';
import 'package:precis/config.dart' as config;
import 'package:precis/country/flutter_country_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryOption extends StatefulWidget {
  @override
  _CountryState createState() => _CountryState();
}

class converter{
  @override
  String serialize(Country t) {
    var map = {"name":t.name, "asset":t.asset, "isoCode":t.isoCode};
    return JSON.jsonEncode(map);
  }
}
class _CountryState extends State<CountryOption> {
  Country _selected;

  saveSelectedCountry(String country) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('country',country);
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: config.backgroundColor,
      body: Center(
        child: CountryPicker(
          showDialingCode: true,
          onChanged: (Country country) {
            setState(() {
              String encodedCountry = converter().serialize(country);
              saveSelectedCountry(encodedCountry);
              
              Navigator.push(context,MaterialPageRoute(
                builder: (context)=>MyApp(country:JSON.jsonDecode(encodedCountry))
              ));
            });
          },
          selectedCountry: _selected,
        ),
      ),
    );
  }
}
