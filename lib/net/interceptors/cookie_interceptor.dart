import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/common/common.dart';

/// Cookie 拦截器
class CookieInterceptor extends Interceptor {
  /// Cookie manager for http requests。Learn more details about
  /// CookieJar please refer to [cookie_jar](https://github.com/flutterchina/cookie_jar)
  final CookieJar cookieJar;

  CookieInterceptor(this.cookieJar);

  @override
  Future onRequest(RequestOptions options) async {
    var cookies = cookieJar.loadForRequest(options.uri);
    cookies.removeWhere((cookie) {
      if (cookie.expires != null) {
        return cookie.expires.isBefore(DateTime.now());
      }
      return false;
    });
    String cookie = getCookies(cookies);
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
        cookieJar.saveFromResponse(
          response.request.uri,
          cookies.map((str) => Cookie.fromSetCookieValue(str)).toList(),
        );
      }
    }
  }

  static String getCookies(List<Cookie> cookies) {
    return cookies.map((cookie) => "${cookie.name}=${cookie.value}").join('; ');
  }
}
