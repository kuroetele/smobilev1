import 'dart:convert' as JSON;
import 'package:flutter/material.dart';
import 'package:snmobile/activities/web_search.dart';
import 'package:snmobile/activities/app.dart';
import 'package:snmobile/country/flutter_country_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

  String _fontSize;
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  Country dafultCountry = Country(
    asset: "assets/flags/ng_flag.png",
    dialingCode: "234",
    isoCode: "NG",
    name: "Nigeria",
  );

  @override
  void initState() {
    _fontSize = 'Font Size';
     config.prepareAppTheme();

    super.initState();
  }

  _saveFontSize(String size) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontsize', double.parse(size));
  }

  _saveSelectedCountry(String country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('country', country);
  }

  _searchRequest(String request) {
    if (request != '') {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SearchWeb(search: request)));
    }
  }

  _onColorChange(Color color) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.setString('background', color.toString());
    setState(() {
      pickerColor = color;
      config.backgroundColor=color;
    });
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
                if (this.actionIcon.icon == Icons.search) {
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
                } else {
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
        width: double.infinity,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            SizedBox(
              width:  MediaQuery.of(context).size.width/2,
              //margin: EdgeInsets.only(bottom: 20),
              child: ListTile(
                title: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text('Change Country',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                ),
                subtitle: CountryPicker(
                  showDialingCode: true,
                  onChanged: (Country country) {
                    setState(() {
                       String encodedCountry = converter().serialize(country);
                      _saveSelectedCountry(encodedCountry);
                      dafultCountry=country;

                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyApp(
                                  country: JSON.jsonDecode(encodedCountry))));
                     });
                  },
                  selectedCountry: dafultCountry,
                ),
                dense: true,
              ),
            ),
            Divider(),
            SizedBox(
              width:  MediaQuery.of(context).size.width/2,
             // margin: EdgeInsets.only(bottom: 20),
              child: ListTile(
                title: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text('Change Font Size',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                ),
                subtitle: DropdownButton(
                  isExpanded: true,
                  underline: SizedBox(),
                  hint: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      _fontSize,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight:FontWeight.w500
                      ),
                    ),
                  ),
                  items: <String>[
                    '12',
                    '14',
                    '16',
                    '18',
                    '20',
                    '22',
                    '24',
                    '26',
                    '28',
                    '30',
                    '32',
                    '34',
                    '36',
                    '38',
                    '40'
                  ].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _fontSize = 'Font Size : $value';
                    });
                    _saveFontSize(value);
                  },
                ),
                dense: true,
              ),
            ),
            Divider(),
            SizedBox(height: 20),
            SizedBox(
              width:  MediaQuery.of(context).size.width/2,
              child: ListTile(
                title: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text('Change Theme',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                ),
                subtitle: FlatButton(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Browse Colors",
                        style: TextStyle(color: Colors.black, fontSize: 20,fontWeight:FontWeight.w500),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        child: AlertDialog(
                          title: const Text('Pick a color!'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: pickerColor,
                              onColorChanged: _onColorChange,
                              enableLabel: true,
                              pickerAreaHeightPercent: 0.8,
                            ),
                            // Use Material color picker:
                            //
                            // child: MaterialPicker(
                            //   pickerColor: pickerColor,
                            //   onColorChanged: changeColor,
                            //   enableLabel: true, // only on portrait mode
                            // ),
                            //
                            // Use Block color picker:
                            //
                            // child: BlockPicker(
                            //   pickerColor: currentColor,
                            //   onColorChanged: changeColor,
                            // ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: const Text('Got it'),
                              onPressed: () {
                                setState(() => currentColor = pickerColor);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
