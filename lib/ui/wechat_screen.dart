import 'package:flutter/material.dart';

class WeChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new WeChatScreenState();
  }
}

class WeChatScreenState extends State<WeChatScreen> {
  String textToShow = "公众号";

  void _updateText() {
    setState(() {
      // update the text
      textToShow = "Flutter is Awesome!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(child: new Text(textToShow)),
      floatingActionButton: new FloatingActionButton(
        heroTag: "wechat",
        onPressed: _updateText,
        tooltip: 'Update Text',
        child: new Icon(Icons.update),
      ),
    );
  }
}
