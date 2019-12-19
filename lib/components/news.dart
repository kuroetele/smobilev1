import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:precis/config.dart';
import 'package:precis/components/news_card.dart';
import 'package:http/http.dart' as http;

class News extends StatefulWidget {
  final type;
  final code;
  final name;
  News({this.type,this.code,this.name});

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {

dynamic _dump=[];
dynamic countryCode='NG';
dynamic newsType='Sports';
dynamic countryName='Nigeria';
bool isFailure = false;
bool isLoading = true;

  @override
  void initState() {
    countryCode=widget.code;
    newsType=widget.type;
    countryName=widget.name;
    _ftechNews(newsType,countryCode);
    super.initState();
  }

  Future _ftechNews(String type, String isoCode) async {
    http.Client client=new http.Client();
    try { 
     
      var uri ='$PROVIDER_URL/top-headlines?country=$isoCode&category=$type&apiKey=$API_KEY';
       print(uri);
      var response = await client.get(Uri.encodeFull(uri));
      if (response.statusCode == 200) {
  
        dynamic data =jsonDecode(response.body)['articles'];
        setState(() {
          _dump=data;
           isFailure = false;
           isLoading = false;
        });
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
      child:
      isLoading ? Center(child: SpinKitRing(
            color: backgroundColor,
            size: 40.0,
      )):
      isFailure ? Center(
            child: Padding(
            padding: EdgeInsets.only(
              top:MediaQuery.of(context).size.height/3
              ),
          child:
            Column(
             children: <Widget>[
               Icon(Icons.warning,color: backgroundColor,size: 50),
               Text(FAILURE),
             ],
        ))):
         _dump == '' ||  _dump == null ||  _dump == 'null' || _dump.length==0
           ? Center(
            child: Padding(
            padding: EdgeInsets.only(
              top:MediaQuery.of(context).size.height/3
            ),
          child:
            Column(
             children: <Widget>[
               Icon(Icons.face,color: backgroundColor,size: 50),
               Text('$newsType News not Availble in $countryName'),
             ],
        )))
       :
      ListView.builder(
        padding: EdgeInsets.only(top: 15.0, bottom: 16.0),
        itemBuilder: (BuildContext context, int index) {
          return NewsCard(post: _dump[index]);
        },
        itemCount: _dump.length,
      ),

    );
  }
}
