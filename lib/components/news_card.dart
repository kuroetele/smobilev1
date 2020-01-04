import 'package:flutter/material.dart';
import 'package:snmobile/activities/preview.dart';
import 'package:snmobile/config.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';

class NewsCard extends StatelessWidget {
  dynamic post = [];
  dynamic time;
  dynamic title, description, url, urlToImage, publishedAt, content;

  NewsCard({this.post}) {
    url = post['url'];
    urlToImage = post['urlToImage'];
    publishedAt = post['publishedAt'];
    content = post['content'];
    title = post['title'];
    description = post['description'];

    time = DateTime.parse(publishedAt);
    publishedAt = timeago.format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding:
          EdgeInsets.only(top: 10.0, bottom: 15.0, left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 2.0),
              blurRadius: 20.0,
            )
          ]),
      child: Column(
        children: <Widget>[
          urlToImage == '' || urlToImage == null || urlToImage == 'null'
              ? Container(
                  width: 0,
                  height: 0,
                )
              : Container(
                  width: double.infinity,
                  child:  CachedNetworkImage(
                      imageUrl: urlToImage,
                      placeholder: (context, url) =>
                           Center(
                                child:  Container(
                                  width: 50.0,
                                  height: 50.0,
                               child: CircularProgressIndicator()),
                              ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
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
                    Text(
                      description,
                      style: TextStyle(color: Colors.black54),
                    )
                  ],
                ),
          Container(
            alignment: Alignment.centerRight,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: <Widget>[
          
                        SizedBox(
                          width: 5,
                        ),
                        Text(publishedAt,
                            style: TextStyle(
                              color: backgroundColor,
                            )),
                        SizedBox(
                          width: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Preview(post: post)));
                          },
                          child: Text(
                            'Read More...',
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
