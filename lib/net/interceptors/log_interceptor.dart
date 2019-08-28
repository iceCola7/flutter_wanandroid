import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/utils/index.dart';

///  Dio 请求日志拦截器
class LogInterceptors extends InterceptorsWrapper {
  bool isDebug = AppConfig.isDebug;

  @override
  onRequest(RequestOptions options) {
    if (isDebug) {
      print('┌────────────────────────Begin Request────────────────────────');
      print('uri: ${options.uri}');
      print('method: ${options.method}');
      print('queryParameters: ${options.queryParameters}');
      print('headers: ${options.headers}');
      // print('cookies: ${options.cookies}');
      if (options.data != null) {
        printLong('body: ' + options.data.toString());
      }
      print(
          '└————————————————————————End Request——————————————————————————\n\n');
    }
    return options;
  }

  @override
  onResponse(Response response) {
    if (isDebug) {
      if (response != null) {
        print(
            '┌────────────────────────Begin Response————————————————————————');
        print('status: ${response.statusCode}');
        print('headers: ${response.headers}');
        printLong('response: ' + response.toString());
        print(
            '└————————————————————————End Response——————————————————————————\n\n');
      }
    }
    return response; // continue
  }

  @override
  onError(DioError err) {
    if (isDebug) {
      print('┌────────────────────────Begin Dio Error————————————————————————');
      print('请求异常: ' + err.toString());
      print('请求异常信息: ' + (err.response?.toString() ?? ''));
      print(
          '└————————————————————————End Dio Error——————————————————————————\n\n');
    }
    return err;
  }
}
