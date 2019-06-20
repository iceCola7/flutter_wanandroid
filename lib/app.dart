import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppState();
  }
}

class AppState extends State<App> {
  String textToShow = "I Like Flutter";

  void _updateText() {
    setState(() {
      // update the text
      textToShow = "Flutter is Awesome!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(""),
      ),
      body: new Center(child: new Text(textToShow)),
      floatingActionButton: new FloatingActionButton(
        onPressed: _updateText,
        tooltip: 'Update Text',
        child: new Icon(Icons.update),
      ),
    );
  }
}
