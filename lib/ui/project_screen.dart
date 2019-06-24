import 'package:flutter/material.dart';

class ProjectScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ProjectScreenState();
  }
}

class ProjectScreenState extends State<ProjectScreen> {
  String textToShow = "项目";

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
        onPressed: _updateText,
        tooltip: 'Update Text',
        child: new Icon(Icons.update),
      ),
    );
  }
}
