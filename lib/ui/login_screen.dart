import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/user_model.dart';
import 'package:flutter_wanandroid/event/login_event.dart';
import 'package:flutter_wanandroid/ui/register_screen.dart';
import 'package:flutter_wanandroid/utils/toast_util.dart';
import 'package:flutter_wanandroid/widgets/loading_dialog.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

/// 登录页面
class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _psdController = TextEditingController();

  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _psdFocusNode = FocusNode();

  Future _login(String username, String password) async {
    if ((null != username && username.length > 0) &&
        (null != password && password.length > 0)) {
      _showLoading(context);
      apiService.login((UserModel model, Response response) {
        _dismissLoading(context);
        if (null != model) {
          if (model.errorCode == Constants.STATUS_SUCCESS) {
            User().saveUserInfo(model, response);
            Application.eventBus.fire(new LoginEvent());
            T.show(msg: "登录成功");
            Navigator.of(context).pop();
          } else {
            T.show(msg: model.errorMsg);
          }
        }
      }, (DioError error) {
        _dismissLoading(context);
        print(error.response);
      }, username, password);
    } else {
      T.show(msg: "用户名或密码不能为空");
    }
  }

  @override
  void initState() {
    // Configure keyboard actions
    // FormKeyboardActions.setKeyboardActions(context, _buildConfig(context));
    super.initState();
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardAction(
          focusNode: _userNameFocusNode,
        ),
        KeyboardAction(
          focusNode: _psdFocusNode,
          closeWidget: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.close),
          ),
        ),
      ],
    );
  }

  /// 显示Loading
  _showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return new LoadingDialog(
            outsideDismiss: false,
            loadingText: "正在登陆...",
          );
        });
  }

  /// 隐藏Loading
  _dismissLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0.4,
            title: Text("登录"),
          ),
          body: Container(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "用户登录",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "请使用WanAndroid账号登录",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                      child: TextField(
                        focusNode: _userNameFocusNode,
                        autofocus: false,
                        controller: _userNameController,
                        decoration: InputDecoration(
                          labelText: "用户名",
                          hintText: "请输入用户名",
                          labelStyle: TextStyle(color: Colors.cyan),
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                      child: TextField(
                        focusNode: _psdFocusNode,
                        controller: _psdController,
                        decoration: InputDecoration(
                          labelText: "密码",
                          labelStyle: TextStyle(color: Colors.cyan),
                          hintText: "请输入密码",
                        ),
                        obscureText: true,
                        maxLines: 1,
                      ),
                    ),

                    // 登录按钮
                    Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              padding: EdgeInsets.all(16.0),
                              elevation: 0.5,
                              child: Text("登录"),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: () {
                                String username = _userNameController.text;
                                String password = _psdController.text;
                                _login(username, password);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          child: Text("还没有账号，注册一个？",
                              style: TextStyle(fontSize: 14)),
                          onPressed: () {
                            registerClick();
                          },
                        )),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void registerClick() async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new RegisterScreen();
    })).then((value) {
      var map = jsonDecode(value);
      var username = map['username'];
      var password = map['password'];
      _userNameController.text = username;
      _psdController.text = password;
      _login(username, password);
    });
  }
}
