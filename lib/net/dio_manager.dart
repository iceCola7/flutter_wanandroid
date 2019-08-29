import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:path_provider/path_provider.dart';

import 'interceptors/log_interceptor.dart';
import 'interceptors/wandroid_error_interceptor.dart';

Dio _dio = Dio();

Dio get dio => _dio;

class DioManager {
  static Future init() async {
    dio.options.baseUrl = Apis.BASE_HOST;
    dio.options.connectTimeout = 30 * 1000;
    dio.options.sendTimeout = 30 * 1000;
    dio.options.receiveTimeout = 30 * 1000;
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };

    // TODO 网络环境监听
    dio.interceptors.add(LogInterceptors());
    dio.interceptors.add(WanAndroidErrorInterceptor());

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path + "/dioCookie";
    print('DioUtil : http cookie path = $tempPath');
    CookieJar cj = PersistCookieJar(dir: tempPath);
    dio.interceptors.add(CookieManager(cj));
  }

  static String parseError(error, {String defErrorString = '网络连接超时或者服务器未响应'}) {
    String errStr;
    if (error is DioError) {
      if (error.type == DioErrorType.CONNECT_TIMEOUT ||
          error.type == DioErrorType.SEND_TIMEOUT ||
          error.type == DioErrorType.RECEIVE_TIMEOUT) {
        errStr = defErrorString;
      } else {
        errStr = error.message;
      }
    }
    return errStr ?? defErrorString;
  }
}
