import 'package:flutter/material.dart';
import 'package:snmobile/activities/web_search.dart';
import 'package:snmobile/config.dart';

class About extends StatefulWidget {
  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<About> {

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
          title: Text(appTitle),
          content: Text(message),
        );
      },
    );
  }

 Widget appBarTitle = new Text('About');
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            backgroundColor: backgroundColor,
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
                  this.appBarTitle = Text("About");
                }
              });
            },
          ),
              IconButton(
                icon: Icon(Icons.notifications,color: Colors.white),
                onPressed: () {
                   alert('No Notifications');
                },
              )
            ],
          ),
          body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child:
               Image.asset('assets/icon/icon.png',width: 100, height:100,)
              ),
              Text('snmobile V1.0', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  
              ),),
               Padding(
                padding: EdgeInsets.only(
                  top:10, right: 40,left: 40
                  ),
                child: Text('info@snmobile.com'),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top:40, right: 60,left: 60
                  ),
                child: Text('Read top news from different news sources including BBC, Aljazeera and many more in summary and in one place. No need for multiple news applications for each news provider.  The platform fetches the latest news and provide to  base on your selected country,  We find the latest, You read easily. '),
              ),
             
            ],
          ),
        ),
       ),
    );
  }
}