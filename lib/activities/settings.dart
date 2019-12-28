import 'dart:convert' as JSON;
import 'package:flutter/material.dart';
import 'package:snmobile/activities/web_search.dart';
import 'package:snmobile/activities/app.dart';
import 'package:snmobile/country/flutter_country_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snmobile/config.dart' as config;

class Settings extends StatefulWidget {
  @override
  _PreviewState createState() => _PreviewState();
}

class converter {
  @override
  String serialize(Country t) {
    var map = {"name": t.name, "asset": t.asset, "isoCode": t.isoCode};
    return JSON.jsonEncode(map);
  }
}

class _PreviewState extends State<Settings> {
  Country _selected;

  void saveSelectedCountry(String country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('country', country);
  }

  void _searchRequest(String request) {
    if (request != '') {
       Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SearchWeb(search: request)));
    }
  }

  void alert(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(config.appTitle),
          content: Text(message),
        );
      },
    );
  }

 
  Widget appBarTitle = new Text("Settings");
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: config.backgroundColor,
        title: appBarTitle,
        actions: <Widget>[
         IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if(this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(Icons.close);
                  this.appBarTitle = new TextField(
                    style: new TextStyle(
                      color: Colors.white,                    
                    ),
                    textInputAction: TextInputAction.search,
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.white),
                        hintText: "Search here...",
                        hintStyle: new TextStyle(color: Colors.white)),
                        onSubmitted: _searchRequest,
                        
                  );
                }else{
                  this.actionIcon = Icon(Icons.search, color: Colors.white);
                  this.appBarTitle = Text("Settings");
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              alert('No Notifications');
            },
          )
        ],
      ),
      body: Container(
        color: config.backgroundColor,
        height: 100.0,
        padding: EdgeInsets.all(20),
        width: double.infinity,
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text('Change Country', style: TextStyle(color: Colors.white)),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: CountryPicker(
                showDialingCode: true,
                onChanged: (Country country) {
                  setState(() {
                    String encodedCountry = converter().serialize(country);
                    saveSelectedCountry(encodedCountry);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyApp(
                                country: JSON.jsonDecode(encodedCountry))));
                  });
                },
                selectedCountry: _selected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
