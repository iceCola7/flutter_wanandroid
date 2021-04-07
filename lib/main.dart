import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/router_config.dart' as myrouter;
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/event/theme_change_event.dart';
import 'package:flutter_wanandroid/res/colors.dart';
import 'package:flutter_wanandroid/ui/splash_screen.dart';
import 'package:flutter_wanandroid/utils/sp_util.dart';
import 'package:flutter_wanandroid/utils/theme_util.dart';

import 'net/index.dart';

/// 在拿不到context的地方通过navigatorKey进行路由跳转：
/// https://stackoverflow.com/questions/52962112/how-to-navigate-without-context-in-flutter-app
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  /// 修改问题: Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized
  /// https://stackoverflow.com/questions/57689492/flutter-unhandled-exception-servicesbinding-defaultbinarymessenger-was-accesse
  WidgetsFlutterBinding.ensureInitialized();

  await SPUtil.getInstance();

  await getTheme();

  runApp(MyApp());

  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，
    // 是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

/// 获取主题
Future<Null> getTheme() async {
  // 是否是夜间模式
  bool dark = SPUtil.getBool(Constants.DARK_KEY, defValue: false);
  ThemeUtils.dark = dark;

  // 如果不是夜间模式，设置的其他主题颜色才起作用
  if (!dark) {
    String themeColorKey =
        SPUtil.getString(Constants.THEME_COLOR_KEY, defValue: 'redAccent');
    if (themeColorMap.containsKey(themeColorKey)) {
      ThemeUtils.currentThemeColor = themeColorMap[themeColorKey];
    }
  }
}

/// 这个 widget 作用这个应用的顶层 widget.
/// 这个 widget 是无状态的，所以我们继承的是 [StatelessWidget].
/// 对应的，有状态的 widget 可以继承 [StatefulWidget]
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  /** 主题模式 */
  ThemeData themeData;

  @override
  void initState() {
    super.initState();
    _initAsync();
    Application.eventBus = new EventBus();
    themeData = ThemeUtils.getThemeData();
    this.registerThemeEvent();
  }

  void _initAsync() async {
    await User().getUserInfo();
    await DioManager.init();
  }

  /// 注册主题改变事件
  void registerThemeEvent() {
    Application.eventBus
        .on<ThemeChangeEvent>()
        .listen((ThemeChangeEvent onData) => this.changeTheme(onData));
  }

  void changeTheme(ThemeChangeEvent onData) async {
    setState(() {
      themeData = ThemeUtils.getThemeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName, // 标题
      debugShowCheckedModeBanner: false, //去掉debug图标
      theme: themeData,
      routes: myrouter.Router.generateRoute(), // 存放路由的配置
      navigatorKey: navigatorKey,
      home: new SplashScreen(), // 启动页
    );
  }

  @override
  void dispose() {
    super.dispose();
    Application.eventBus.destroy();
  }
}
