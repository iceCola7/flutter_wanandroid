import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/main.dart';

/// 启动页面
class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => Main()),
          (route) => route == null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Stack(
        children: <Widget>[
          new Image.asset(
            "assets/images/loading.png",
            fit: BoxFit.cover,
          )
        ],
      ),
    );
  }
}
