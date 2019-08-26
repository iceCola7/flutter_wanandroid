import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/event/login_event.dart';
import 'package:flutter_wanandroid/event/theme_change_event.dart';
import 'package:flutter_wanandroid/ui/about_screen.dart';
import 'package:flutter_wanandroid/ui/collect_screen.dart';
import 'package:flutter_wanandroid/ui/login_screen.dart';
import 'package:flutter_wanandroid/ui/setting_screen.dart';
import 'package:flutter_wanandroid/ui/todo_screen.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';
import 'package:flutter_wanandroid/utils/sp_util.dart';
import 'package:flutter_wanandroid/utils/theme_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 侧滑页面
class DrawerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DrawerScreenState();
  }
}

class DrawerScreenState extends State<DrawerScreen> {
  bool isLogin = false;
  String username = "未登录";

  @override
  void initState() {
    super.initState();
    this.registerLoginEvent();

    if (null != User.singleton.userName && User.singleton.userName.isNotEmpty) {
      isLogin = true;
      username = User.singleton.userName;
    }
  }

  void registerLoginEvent() {
    Application.eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        isLogin = true;
        username = User.singleton.userName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: InkWell(
              child: Text(
                username,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
              ),
              onTap: () {
                if (!isLogin) {
                  RouteUtil.push(context, LoginScreen());
                }
              },
            ),
            currentAccountPicture: InkWell(
              child: CircleAvatar(
                backgroundImage:
                    AssetImage("assets/images/ic_default_avatar.png"),
              ),
            ),
          ),
          ListTile(
            title: Text(
              "收藏",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
            leading: Icon(Icons.collections,
                size: 22, color: Theme.of(context).primaryColor),
            onTap: () {
              if (isLogin) {
                RouteUtil.push(context, CollectScreen());
              } else {
                Fluttertoast.showToast(msg: "请先登录~");
                RouteUtil.push(context, LoginScreen());
              }
            },
          ),
          ListTile(
            title: Text(
              "TODO",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
            leading: Icon(Icons.description,
                size: 22, color: Theme.of(context).primaryColor),
            onTap: () {
              if (isLogin) {
                RouteUtil.push(context, TodoScreen());
              } else {
                Fluttertoast.showToast(msg: "请先登录~");
                RouteUtil.push(context, LoginScreen());
              }
            },
          ),
          ListTile(
            title: Text(
              "夜间模式",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
            leading: Icon(Icons.brightness_2,
                size: 22, color: Theme.of(context).primaryColor),
            onTap: () {
              setState(() {
                changeTheme();
              });
            },
          ),
          ListTile(
            title: Text(
              "设置",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
            leading: Icon(Icons.settings,
                size: 22, color: Theme.of(context).primaryColor),
            onTap: () {
              RouteUtil.push(context, SettingScreen());
            },
          ),
          ListTile(
            title: Text(
              "关于",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
            leading: Icon(Icons.info,
                size: 22, color: Theme.of(context).primaryColor),
            onTap: () {
              RouteUtil.push(context, AboutScreen());
            },
          ),
          Offstage(
            offstage: !isLogin,
            child: ListTile(
              title: Text(
                "注销",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              ),
              leading: Icon(Icons.power_settings_new,
                  size: 22, color: Theme.of(context).primaryColor),
              onTap: () {
                _logout(context);
              },
            ),
          )
        ],
      ),
    );
  }

  /// 改变主题
  changeTheme() async {
    ThemeUtils.dark = !ThemeUtils.dark;
    SPUtil.putBool(Constants.DARK_KEY, ThemeUtils.dark);
    Application.eventBus.fire(new ThemeChangeEvent());
  }

  /// 退出登录
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        // title: new Text(''),
        content: new Text('确定退出登录吗？'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('取消', style: TextStyle(color: Colors.cyan)),
          ),
          new FlatButton(
            onPressed: () => {
              ApiService().logout((BaseModel model) {
                Navigator.of(context).pop(true);
                if (model.errorCode == Constants.STATUS_SUCCESS) {
                  User.singleton.clearUserInfo();
                  setState(() {
                    isLogin = false;
                    username = "未登录";
                  });
                } else {
                  Fluttertoast.showToast(msg: model.errorMsg);
                }
              }, (DioError error) {
                print(error.response);
              })
            },
            child: new Text('确定', style: TextStyle(color: Colors.cyan)),
          ),
        ],
      ),
    );
  }
}
