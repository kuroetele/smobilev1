import 'package:flutter/material.dart';
import 'package:snmobile/activities/web_search.dart';
import 'package:snmobile/config.dart' as config;
import 'dart:convert';
import 'dart:typed_data';
import 'package:snmobile/components/voice_speech.dart';
import 'package:snmobile/components/voice_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nice_button/nice_button.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

class Preview extends StatefulWidget {
  final post;
  Preview({this.post});

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  dynamic post = [];
  dynamic title, description, url, urlToImage, publishedAt, content;

  int playing = 0;
  bool down = false;
  String playerTitle = 'Play';
  String emailInput = '';
  MyPlayer audioPlayer = MyPlayer();
  TextEditingController _controller = new TextEditingController();

  Widget appBarTitle;
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  void initState() {
    config.prepareAppTheme();
    setState(() {
      post = widget.post;
      url = post['url'];
      urlToImage = post['urlToImage'];
      publishedAt = post['publishedAt'];
      content = post['content'];
      title = post['title'];
      description = post['description'];
      description = '$title \n\n  $description \n $content';
    });
    addAsRedArticle();
    appBarTitle = Text(title);
    super.initState();
  }

  @override
  void dispose() {
    _pauses();
    super.dispose();
  }

  void addAsRedArticle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(url, url);
  }

  void alert(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(config.appTitle),
          content: Text(message),
          actions: <Widget>[
          FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _pauses() async {
    final val = await audioPlayer.pause();
    if (val == 1) {
      setState(() {
        playing = 0;
        playerTitle = 'Play';
      });
    }
  }

  _plays(String text) async {
    if (down == false) {
      setState(() {
        playing = 1;
        playerTitle = 'Loading..';
      });

      var response = await getVoice(text);
      var resData = jsonDecode(response.body);
      String audioBase64 = resData['audioContent'];
      Uint8List bytes = base64Decode(audioBase64);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/audio.mp3');

      if (await file.exists()) {
        file.delete();
      }
      await file.writeAsBytes(bytes);
      final val = await audioPlayer.play();
      if (val == 1) {
        setState(() {
          playing = 2;
          playerTitle = 'Playing..';
          down = true;
        });
      }
    } else {
      final val = await audioPlayer.play();
      if (val == 1) {
        setState(() {
          playing = 2;
          playerTitle = 'Playing..';
          down = true;
        });
      }
    }
  }

  _searchRequest(String request) {
    if (request != '') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SearchWeb(search: request)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: config.backgroundColor,
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = Icon(Icons.close);
                  this.appBarTitle = TextField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        hintText: "Search here...",
                        hintStyle: TextStyle(color: Colors.white)),
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
      body: ListView(children: <Widget>[
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
                         constraints: BoxConstraints(minHeight: 80),
                        child: CachedNetworkImage(
                          imageUrl: urlToImage,
                          placeholder: (context, url) =>
                             Center(
                                child:  Container(
                                  width: 50.0,
                                  height: 50.0,
                               child: CircularProgressIndicator()),
                              ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
                ),
              ),
              description == '' || description == null || description == 'null'
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
        Divider(),
        Container(
          padding: EdgeInsets.all(20.0),
          color: Colors.white,
          child: Row(children: [
            Expanded(
                child: Row(
              children: <Widget>[
                playing == 0
                    ? InkWell(
                        onTap: () {
                          String s = "";
                          if (title != null && title != '') {
                            s = title;
                          }
                          if (description != null && description != '') {
                            s = s + '. ' + description;
                          }
                          if (content != null && content != '') {
                            s = s + '. ' + content;
                          }
                          _plays(s);
                        },
                        child: Icon(Icons.play_circle_filled,
                            size: 40, color: config.backgroundColor))
                    : playing == 1
                        ? Icon(Icons.pause_circle_outline,
                            size: 40, color: config.backgroundColor)
                        : InkWell(
                            onTap: () {
                              _pauses();
                            },
                            child: Icon(Icons.pause_circle_filled,
                                size: 40, color: config.backgroundColor)),
                Text(
                  playerTitle,
                  style: TextStyle(color: config.backgroundColor),
                ),
              ],
            )),
            Expanded(
                child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    String s = "";
                    if (title != null && title != '') {
                      s = title;
                    }
                    if (description != null && description != '') {
                      s = s + '. \n\n' + description;
                    }
                    if (content != null && content != '') {
                      s = s + '. \n\n' + content;
                    }
                    s = s + '\n\n' + url;
                    Share.share(s, subject: title);
                  },
                  child: Icon(
                    Icons.screen_share,
                    size: 40,
                    color: config.backgroundColor,
                  ),
                ),
                Text(
                  ' Share',
                  style: TextStyle(color: config.backgroundColor),
                ),
              ],
            )),
            Expanded(
                child: Row(
              children: <Widget>[
                SizedBox(
                  width: 50,
                )
              ],
            )),
          ]),
        ),
        Divider(),
        Container(
          padding: EdgeInsets.all(32.0),
          margin: EdgeInsets.only(top: 20),
          child: Center(
            child: Column(
              children: <Widget>[
                Text('Subscribe for Newsletter',
                    style: TextStyle(
                      fontSize: 30,
                    )),
                SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  onChanged: (text) {
                    setState(() {
                      emailInput = text;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red, //this has no effect
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: "Email Address",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: NiceButton(
                      radius: 40,
                      padding: const EdgeInsets.all(15),
                      text: "Subscribe ",
                      background: config.backgroundColor,
                      onPressed: () {
                        if (emailInput != '' &&
                            emailInput != null &&
                            emailInput.length > 3 &&
                            emailInput.contains('@') &&
                            emailInput.contains('.')) {
                           config.subscribe(emailInput,'$MediaQuery(context).session');
                          _controller.clear();
                          alert(
                              'Subscribed successfully, newsletter will now be pushed to $emailInput');
                          setState(() {
                            emailInput = '';
                          });
                        } else {
                          alert('Oops! Invalid Email Address');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
