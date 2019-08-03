import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/event/login_event.dart';
import 'package:flutter_wanandroid/ui/collect_screen.dart';
import 'package:flutter_wanandroid/ui/login_screen.dart';
import 'package:flutter_wanandroid/ui/todo_screen.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';
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

    User().getUserInfo();
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
              "我的收藏",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
            leading: Icon(
              Icons.collections,
              size: 22,
            ),
            onTap: () {
              if (isLogin) {
                RouteUtil.push(context, CollectScreen());
              } else {
                Fluttertoast.showToast(msg: "清先登录！");
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
            leading: Icon(
              Icons.description,
              size: 22,
            ),
            onTap: () {
              if (isLogin) {
                RouteUtil.push(context, TodoScreen());
              } else {
                Fluttertoast.showToast(msg: "清先登录！");
                RouteUtil.push(context, LoginScreen());
              }
            },
          ),
          ListTile(
            title: Text(
              "设置",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
            leading: Icon(
              Icons.settings,
              size: 22,
            ),
            onTap: () {
              Fluttertoast.showToast(msg: "该功能正在开发中...");
            },
          ),
          ListTile(
            title: Text(
              "关于我们",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
            leading: Icon(
              Icons.info,
              size: 22,
            ),
            onTap: () {
              Fluttertoast.showToast(msg: "该功能正在开发中...");
            },
          ),
          Offstage(
            offstage: !isLogin,
            child: ListTile(
              title: Text(
                "退出登录",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              ),
              leading: Icon(
                Icons.power_settings_new,
                size: 22,
              ),
              onTap: () {
                _logout(context);
              },
            ),
          )
        ],
      ),
    );
  }

  /// 退出登录
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
            title: new Text('提示'),
            content: new Text('确定退出登录吗？'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('取消'),
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
                child: new Text('确定'),
              ),
            ],
          ),
    );
  }
}
