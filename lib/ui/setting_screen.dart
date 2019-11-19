import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/event/theme_change_event.dart';
import 'package:flutter_wanandroid/res/colors.dart';
import 'package:flutter_wanandroid/ui/qr_code_screen.dart';
import 'package:flutter_wanandroid/utils/sp_util.dart';
import 'package:flutter_wanandroid/utils/theme_util.dart';

import '../utils/route_util.dart';
import 'about_screen.dart';

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
        elevation: 0.4,
        title: Text('设置'),
      ),
      body: ListView(
        children: <Widget>[
          new ExpansionTile(
            title: new Row(
              children: <Widget>[
                Icon(Icons.color_lens, color: Theme.of(context).primaryColor),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('主题'),
                )
              ],
            ),
            children: <Widget>[
              new Wrap(
                children: themeColorMap.keys.map((String key) {
                  Color value = themeColorMap[key];
                  return new InkWell(
                    onTap: () {
                      SPUtil.putString(Constants.THEME_COLOR_KEY, key);
                      ThemeUtils.currentThemeColor = value;
                      Application.eventBus.fire(ThemeChangeEvent());
                    },
                    child: new Container(
                      margin: EdgeInsets.all(5.0),
                      width: 36.0,
                      height: 36.0,
                      color: value,
                    ),
                  );
                }).toList(),
              )
            ],
          ),
          new ListTile(
            trailing: Icon(Icons.chevron_right),
            title: new Row(
              children: <Widget>[
                Icon(Icons.feedback, color: Theme.of(context).primaryColor),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('意见反馈'),
                )
              ],
            ),
            onTap: () {
              var url = 'https://github.com/iceCola7/flutter_wanandroid/issues';
              RouteUtil.launchInBrowser(url);
            },
          ),
          new ListTile(
            trailing: Icon(Icons.chevron_right),
            title: new Row(
              children: <Widget>[
                Icon(Icons.settings_overscan,
                    color: Theme.of(context).primaryColor),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('扫码下载'),
                )
              ],
            ),
            onTap: () {
              RouteUtil.push(context, QrCodeScreen());
            },
          ),
          new ListTile(
            trailing: Icon(Icons.chevron_right),
            title: Row(
              children: <Widget>[
                Icon(Icons.info, color: Theme.of(context).primaryColor),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('关于'),
                )
              ],
            ),
            onTap: () {
              RouteUtil.push(context, AboutScreen());
            },
          ),
        ],
      ),
    );
  }
}
