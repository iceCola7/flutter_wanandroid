import 'package:flutter/material.dart';

class ComModel {
  String title;
  String subtitle;
  String content;
  String extra;
  String url;
  bool isShowArrow;
  Widget page;

  ComModel(
      {this.title,
      this.subtitle,
      this.content,
      this.extra,
      this.url,
      this.isShowArrow,
      this.page});

  ComModel.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? '',
        subtitle = json['subtitle'] ?? '',
        content = json['content'] ?? '',
        extra = json['extra'] ?? '',
        url = json['url'] ?? '',
        isShowArrow = json['isShowArrow'] ?? false;

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'content': content,
        'extra': extra,
        'url': url,
        'isShowArrow': isShowArrow
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"title\":\"$title\"");
    sb.write("\"subtitle\":\"$subtitle\"");
    sb.write(",\"content\":\"$content\"");
    sb.write(",\"url\":\"$url\"");
    sb.write(",\"isShowArrow\":\"$isShowArrow\"");
    sb.write('}');
    return sb.toString();
  }
}
