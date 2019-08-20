import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/event/theme_change_event.dart';
import 'package:flutter_wanandroid/res/colors.dart';
import 'package:flutter_wanandroid/utils/sp_util.dart';
import 'package:flutter_wanandroid/utils/theme_util.dart';

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
      body: ListView(
        children: <Widget>[
          new ExpansionTile(
            title: new Row(
              children: <Widget>[
                Icon(Icons.color_lens, color: Colors.grey[600]),
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
        ],
      ),
    );
  }
}
