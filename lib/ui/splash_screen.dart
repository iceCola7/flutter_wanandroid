import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/res/styles.dart';
import 'package:flutter_wanandroid/ui/main_screen.dart';
import 'package:flutter_wanandroid/utils/theme_util.dart';
import 'package:flutter_wanandroid/utils/utils.dart';

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
          new MaterialPageRoute(builder: (context) => MainScreen()),
          (route) => route == null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Stack(
        children: <Widget>[
          Container(
            color: ThemeUtils.dark ? Color(0xFF212A2F) : Colors.grey[200],
            alignment: Alignment.center,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Card(
                  color: Theme.of(context).primaryColor,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0))),
                  child: new Image.asset(
                    Utils.getImgPath('ic_launcher_news'),
                    width: 72.0,
                    height: 72.0,
                    fit: BoxFit.fill,
                  ),
                ),
                Gaps.vGap10,
                Text(
                  AppConfig.appName,
                  style: new TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
