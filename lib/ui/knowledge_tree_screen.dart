import 'package:flutter/material.dart';

class KnowledgeTreeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new KnowledgeTreeState();
  }
}

class KnowledgeTreeState extends State<KnowledgeTreeScreen> {
  String textToShow = "知识体系";

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
