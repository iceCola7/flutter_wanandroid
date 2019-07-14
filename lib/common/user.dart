import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/data/model/user_model.dart';
import 'package:flutter_wanandroid/utils/sp_util.dart';

class User {
  static final User singleton = User._internal();

  factory User() {
    return singleton;
  }

  User._internal();

  List<String> cookie;
  String userName;

  void saveUserInfo(UserModel _userModel, Response response) {
    List<String> cookies = response.headers["set-cookie"];
    cookie = cookies;
    userName = _userModel.data.username;
    saveInfo();
  }

  Future<Null> getUserInfo() async {
    List<String> cookies = SPUtil.getStringList("cookies");
    if (cookies != null) {
      cookie = cookies;
    }

    String username = SPUtil.getString("username");
    if (username != null) {
      userName = username;
    }
  }

  saveInfo() async {
    SPUtil.putStringList("cookies", cookie);
    SPUtil.putString("username", userName);
  }

  void clearUserInfo() {
    cookie = null;
    userName = null;
    clearInfo();
  }

  clearInfo() async {
    SPUtil.putString("cookies", null);
    SPUtil.putString("username", null);
  }
}
