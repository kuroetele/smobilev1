import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:snmobile/activities/about.dart';
import 'package:snmobile/activities/settings.dart';
import 'package:snmobile/activities/web_search.dart';
import 'package:snmobile/components/news.dart';
import 'package:snmobile/config.dart' as config;

class MyApp extends StatefulWidget {
  final country;
  MyApp({this.country});
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {

  TabController controller;
  String countryName;
  String countryCode;
  String countryFlag;
  Widget appBarTitle;

  @override
  void initState() {
    setState(() {
          countryCode=widget.country['isoCode'];
          countryName=widget.country['name'];
          countryFlag=widget.country['asset'];
       
    });
     appBarTitle=new Text('snmobile - $countryName');
    controller = TabController(vsync: this, length: 6);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _searchRequest(String request){
     if(request!=''){
       Navigator.push(context,MaterialPageRoute(
         builder: (context)=>SearchWeb(search: request)
       ));
     }
  }

  void alert(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('snmobile - $countryName'),
          content: Text(message),
        );
      },
    );
  }


 Icon actionIcon = new Icon(
     Icons.search,
    color: Colors.white,
  );


  @override
  Widget build(BuildContext context) {

  
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 100.0),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.transparent,
              offset: Offset(0, 2.0),
              blurRadius: 20.0,
            )
          ]),
          child: AppBar(
            backgroundColor: config.backgroundColor,
            title: appBarTitle,
            actions: <Widget>[
              IconButton(
                  icon: actionIcon,
                  onPressed: () {
                    setState(() {
                      if(actionIcon.icon == Icons.search) {
                        actionIcon = new Icon(Icons.close);
                        appBarTitle = new TextField(
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
                        actionIcon = Icon(Icons.search, color: Colors.white);
                        appBarTitle =Text('snmobile - $countryName');
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
            bottom: TabBar(
              isScrollable: true,
              controller: controller,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: new BubbleTabIndicator(
                indicatorHeight: 25.0,
                indicatorColor: Colors.white,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              tabs: <Widget>[
                Tab(
                  text: "Sports",
                ),
                Tab(
                  text: "Entertainment",
                ),
                Tab(
                  text: "Business",
                ),
                Tab(
                  text: "Technology",
                ),
                Tab(
                  text: "Health",
                ),
                Tab(
                  text: "Science",
                ),
              ],
              onTap: (int val) {},
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: UserAccountsDrawerHeader(
                accountName: Text('snmobile - $countryName'),
                accountEmail: Text('info@snmobile.'+countryCode.toLowerCase()),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
                decoration: BoxDecoration(color: config.backgroundColor),
              ),
            ),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Text('Home'),
                  leading: Icon(Icons.home),
                )),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Settings()));
                },
                child: ListTile(
                  title: Text('Settings'),
                  leading: Icon(Icons.settings),
                )),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => About()));
                },
                child: ListTile(
                  title: Text('About'),
                  leading: Icon(Icons.help),
                )),
          ],
        ),
      ),
      body:Container(
            width: double.infinity,
            child: 
            TabBarView(
              controller: controller,
              children: <Widget>[
                News(
                  type: "Sports",
                  code:countryCode,
                  name:countryName
                ),
                News(
                  type: "Entertainment",
                   code:countryCode,
                   name:countryName
                ),
                News(
                  type: "Business",
                  code:countryCode,
                  name:countryName
                ),
                News(
                  type: "Technology",
                  code:countryCode,
                  name:countryName
                ),
                News(
                  type: "Health",
                  code:countryCode,
                  name:countryName
                ),
                News(
                  type: "Science",
                  code:countryCode,
                  name:countryName
                ),
              ],
            ),
          ),
    );
  }
}
