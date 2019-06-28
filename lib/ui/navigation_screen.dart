import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NavigationScreenState();
  }
}

class NavigationScreenState extends State<NavigationScreen> {
  String textToShow = "导航";

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
        heroTag: "navigation",
        onPressed: _updateText,
        tooltip: 'Update Text',
        child: new Icon(Icons.update),
      ),
    );
  }
}
