import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/utils/index.dart';

///  Dio 请求日志拦截器
class LogInterceptors extends InterceptorsWrapper {
  bool isDebug = AppConfig.isDebug;

  @override
  onRequest(RequestOptions options) {
    if (isDebug) {
      print('┌─────────────────────Begin Request─────────────────────');
      printKV('uri', options.uri);
      printKV('method', options.method);
      printKV('queryParameters', options.queryParameters);
      printKV('contentType', options.contentType.toString());
      printKV('responseType', options.responseType.toString());

      StringBuffer stringBuffer = new StringBuffer();
      options.headers.forEach((key, v) => stringBuffer.write('\n  $key: $v'));
      printKV('headers', stringBuffer.toString());
      stringBuffer.clear();

      if (options.data != null) {
        printKV('body', options.data);
      }
      print('└—————————————————————End Request———————————————————————\n\n');
    }
    return options;
  }

  @override
  onResponse(Response response) {
    if (isDebug) {
      print('┌─────────────────────Begin Response—————————————————————');
      printKV('uri', response.request.uri);
      printKV('status', response.statusCode);
      printKV('responseType', response.request.responseType.toString());

      StringBuffer stringBuffer = new StringBuffer();
      response.headers.forEach((key, v) => stringBuffer.write('\n  $key: $v'));
      printKV('headers', stringBuffer.toString());
      stringBuffer.clear();

      // printLong('response: ' + response.toString());

      print('└—————————————————————End Response———————————————————————\n\n');
    }
    return response;
  }

  @override
  onError(DioError err) {
    if (isDebug) {
      print('┌─────────────────────Begin Dio Error—————————————————————');
      printKV('error', err.toString());
      printKV('error message', (err.response?.toString() ?? ''));
      print('└—————————————————————End Dio Error———————————————————————\n\n');
    }
    return err;
  }

  printKV(String key, Object value) {
    printLong('$key: $value');
  }
}
