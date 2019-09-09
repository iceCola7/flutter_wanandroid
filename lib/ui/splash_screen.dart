import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/ui/main_screen.dart';
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
            color: Theme.of(context).primaryColor,
            // ThemeUtils.dark ? Color(0xFF212A2F) : Colors.grey[200],
            alignment: Alignment.center,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(48.0))),
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).primaryColor,
                    margin: EdgeInsets.all(2.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(46.0))),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage(Utils.getImgPath('ic_launcher_news')),
                      radius: 46.0,
                    ),
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
