import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/user_model.dart';
import 'package:flutter_wanandroid/event/login_event.dart';
import 'package:flutter_wanandroid/ui/register_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _psdController = TextEditingController();

  Future<Null> _login() async {
    String username = _userNameController.text;
    String password = _psdController.text;

    if ((null != username && username.length > 0) &&
        (null != password && password.length > 0)) {
      ApiService().login((UserModel model, Response response) {
        if (null != model) {
          if (model.errorCode == Constants.STATUS_SUCCESS) {
            User().saveUserInfo(model, response);
            Application.eventBus.fire(new LoginEvent());
            Fluttertoast.showToast(msg: "登录成功");
            Navigator.of(context).pop();
          } else {
            Fluttertoast.showToast(msg: model.errorMsg);
          }
        }
      }, (DioError error) {
        print(error.response);
      }, username, password);
    } else {
      Fluttertoast.showToast(msg: "用户名或密码不能为空");
    }
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
                    TextField(
                      autofocus: true,
                      controller: _userNameController,
                      decoration: InputDecoration(
                        labelText: "用户名",
                        hintText: "请输入用户名",
                        labelStyle: TextStyle(color: Color(0xFF00BCD4)),
                      ),
                      maxLines: 1,
                    ),
                    TextField(
                      controller: _psdController,
                      decoration: InputDecoration(
                        labelText: "密码",
                        labelStyle: TextStyle(color: Color(0xFF00BCD4)),
                        hintText: "请输入密码",
                      ),
                      obscureText: true,
                      maxLines: 1,
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
                              color: Color(0xFF00BCD4),
                              textColor: Colors.white,
                              onPressed: () {
                                _login();
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
    }));
  }
}
