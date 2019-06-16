import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoadingState();
  }
}

class _LoadingState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Stack(
        children: <Widget>[
          Image.asset(
            "./images/loading.png",
            fit: BoxFit.cover,
          )
        ],
      ),
    );
  }
}
