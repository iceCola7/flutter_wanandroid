import 'package:flutter/material.dart';

class ComModel {
  String title;
  String content;
  String extra;
  String url;
  bool isShowArrow;
  Widget page;

  ComModel(
      {this.title,
      this.content,
      this.extra,
      this.url,
      this.isShowArrow,
      this.page});

  ComModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        content = json['content'],
        extra = json['extra'],
        url = json['url'],
        isShowArrow = json['isShowArrow'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'extra': extra,
        'url': url,
        'isShowArrow': isShowArrow
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"title\":\"$title\"");
    sb.write(",\"content\":\"$content\"");
    sb.write(",\"url\":\"$url\"");
    sb.write(",\"isShowArrow\":\"$isShowArrow\"");
    sb.write('}');
    return sb.toString();
  }
}
