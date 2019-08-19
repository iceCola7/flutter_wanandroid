import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wanandroid/app.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/event/theme_change_event.dart';
import 'package:flutter_wanandroid/loading.dart';
import 'package:flutter_wanandroid/ui/splash_screen.dart';
import 'package:flutter_wanandroid/utils/sp_util.dart';
import 'package:flutter_wanandroid/utils/theme_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  bool dark = await getTheme();

  runApp(MyApp(dark));
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，
    // 是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

/// 获取是否是夜间模式
Future<bool> getTheme() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool dark = sp.getBool(Constants.DARK_KEY);
  if (dark == null) {
    dark = false;
  }
  ThemeUtils.dark = dark;
  return dark;
}

class MyApp extends StatefulWidget {
  final bool dark;

  MyApp(this.dark);

  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Color themeColor = ThemeUtils.currentThemeColor;

  ThemeData themeData;

  @override
  void initState() {
    super.initState();
    _initAsync();
    Application.eventBus = new EventBus();
    themeData = ThemeUtils.getThemeData(widget.dark);
    this.registerThemeEvent();
  }

  void _initAsync() async {
    await SPUtil.getInstance();
  }

  /// 注册主题改变事件
  void registerThemeEvent() {
    Application.eventBus
        .on<ThemeChangeEvent>()
        .listen((ThemeChangeEvent onData) => this.changeTheme(onData));
  }

  void changeTheme(ThemeChangeEvent onData) {
    setState(() {
      themeData = ThemeUtils.getThemeData(onData.dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "玩Android",
      debugShowCheckedModeBanner: false,
      theme: themeData,
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
