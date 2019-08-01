import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 注册页面
class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _psdController = TextEditingController();
  TextEditingController _psdAgainController = TextEditingController();

  Future<Null> _register() async {
    String username = _userNameController.text;
    String password = _psdController.text;
    String passwordAgain = _psdAgainController.text;
    if (password != passwordAgain) {
      Fluttertoast.showToast(msg: "两次密码输入不一致！");
    } else {
      ApiService().register((UserModel _userModel) {
        if (_userModel != null) {
          if (_userModel.errorCode == 0) {
            Fluttertoast.showToast(msg: "注册成功！");
            Navigator.of(context).pop();
          } else {
            Fluttertoast.showToast(msg: _userModel.errorMsg);
          }
        }
      }, (DioError error) {
        print(error.response);
      }, username, password);
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
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0.4,
            title: Text("注册"),
          ),
          body: Padding(
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
                      "注册用户",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "用户注册后才可以登录！",
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
                  TextField(
                    controller: _psdAgainController,
                    decoration: InputDecoration(
                      labelText: "再次输入密码",
                      labelStyle: TextStyle(color: Color(0xFF00BCD4)),
                      hintText: "请再次输入密码",
                    ),
                    obscureText: true,
                    maxLines: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.all(16.0),
                            elevation: 0.5,
                            child: Text("注册"),
                            color: Color(0xFF00BCD4),
                            textColor: Colors.white,
                            onPressed: () {
                              _register();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
