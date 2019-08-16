import 'package:flutter/material.dart';

/// 设置页面
class SettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SettingScreenState();
  }
}

class SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: Container(
        child: Text(''),
      ),
    );
  }
}
