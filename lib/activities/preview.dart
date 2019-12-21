import 'package:flutter/material.dart';
import 'package:precis/activities/web_search.dart';
import 'package:precis/config.dart';
import 'package:share/share.dart';

class Preview extends StatefulWidget {
  final post;
  Preview({this.post});

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  dynamic post = [];
  dynamic title, description, url, urlToImage, publishedAt, content;
  Widget appBarTitle;
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  void initState() {
    setState(() {
      post = widget.post;
      url = post['url'];
      urlToImage = post['urlToImage'];
      publishedAt = post['publishedAt'];
      content = post['content'];
      title = post['title'];
      description = title + "\n\n" + post['description'] + "\n" + content;
    });
    appBarTitle = new Text(title);
    super.initState();
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

  void _searchRequest(String request) {
    if (request != '') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SearchWeb(search: request)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(title),
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
                  this.appBarTitle = Text(title);
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
      body: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: urlToImage == '' ||
                          urlToImage == null ||
                          urlToImage == 'null'
                      ? Container(
                          width: 0,
                          height: 0,
                        )
                      : Container(
                          width: double.infinity,
                          child: Image.network(urlToImage),
                        ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    title,
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
                  ),
                ),
                description == '' ||
                        description == null ||
                        description == 'null'
                    ? Container(
                        width: 0,
                        height: 0,
                      )
                    : Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              description,
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                content == '' || content == null || content == 'null'
                    ? Container(
                        width: 0,
                        height: 0,
                      )
                    : Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              content,
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          
          Container(
            padding: EdgeInsets.all(10.0),
            width: 150.0,
            child: InkWell(
              onTap: (){
                Share.share('$description \n\n $content $url', subject: '[Precis -News]\n$title');
              },
              child: Row(
                children: <Widget>[
                  Image.asset('assets/images/share.png', width: 40.0,height:50.0),
                  Text(' Share'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
