import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/utils/sp_util.dart';

/// Cookie 拦截器
class CookieInterceptor2 extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    String cookie = SPUtil.getStringList(Constants.COOKIES_KEY).toString();
    if (cookie.isNotEmpty) options.headers[HttpHeaders.cookieHeader] = cookie;
  }

  @override
  Future onResponse(Response response) async => _saveCookies(response);

  @override
  Future onError(DioError err) async => _saveCookies(err.response);

  _saveCookies(Response response) {
    if (response != null && response.headers != null) {
      String uri = response.request.uri.toString();
      List<String> cookies = response.headers[HttpHeaders.setCookieHeader];
      if (cookies != null &&
          (uri.contains(Constants.SAVE_USER_LOGIN_KEY) ||
              uri.contains(Constants.SAVE_USER_REGISTER_KEY))) {
        SPUtil.putStringList(Constants.COOKIES_KEY, cookies);
      }
    }
  }

  static String getCookies(List<Cookie> cookies) {
    return cookies.map((cookie) => "${cookie.name}=${cookie.value}").join('; ');
  }
}
