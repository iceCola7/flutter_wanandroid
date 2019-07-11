import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wanandroid/app.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/loading.dart';
import 'package:flutter_wanandroid/ui/splash_screen.dart';
import 'package:flutter_wanandroid/utils/sp_util.dart';
import 'package:flutter_wanandroid/utils/theme_util.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，
    // 是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Color themeColor = ThemeUtils.currentColorTheme;

  @override
  void initState() {
    super.initState();
    Application.eventBus = new EventBus();
    _initAsync();
  }

  void _initAsync() async {
    await SPUtil.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "玩Android",
      debugShowCheckedModeBanner: false,
      theme:
          new ThemeData(primaryColor: themeColor, brightness: Brightness.light),
      routes: <String, WidgetBuilder>{
        "app": (BuildContext context) => new App(),
        "splash": (BuildContext context) => new SplashScreen()
      },
      home: new LoadingPage(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Application.eventBus.destroy();
  }
}
