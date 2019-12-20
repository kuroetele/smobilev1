import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:precis/config.dart' ;
import 'package:webview_flutter/webview_flutter.dart';

class SearchWeb extends StatefulWidget {
  
  final String search;
  SearchWeb({this.search});

  @override
  SearchWebState createState() => SearchWebState();
}

class SearchWebState extends State<SearchWeb> {
 
  String selectedUrl='https://www.google.com';
  final Completer<WebViewController> _controller =Completer<WebViewController>();

  Widget appBarTitle; 
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  void initState() {
    setState(() {  
        var search=widget.search;
        selectedUrl='https://www.google.com/search?q=$search';
        appBarTitle= new Text(widget.search);
   });
    super.initState();
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
          title: Text(appTitle),
          content: Text(message),
        );
      },
    );
  }

 
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
                  this.appBarTitle = Text(widget.search);
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
      body: 
      WebView(
        initialUrl: selectedUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished:(String url){
        },
        
        onWebViewCreated: (WebViewController webViewController) {
            setState(() {
            });
          _controller.complete(webViewController);
        },
      )
    );
  }
}