import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/ui/webview_screen.dart';

/// 路由工具类
class RouteUtil {
  /// 跳转到 WebView 打开
  static void toWebView(BuildContext context, String title, String link) async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new WebViewScreen(
        title: title,
        url: link,
      );
    }));
  }

  static Future push(BuildContext context, Widget widget) {
    return Navigator.push(
        context, new MaterialPageRoute(builder: (context) => widget));
  }
}
