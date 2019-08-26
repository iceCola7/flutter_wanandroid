import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/ui/webview_screen.dart';
import 'package:url_launcher/url_launcher.dart';

/// 路由工具类
class RouteUtil {
  /// 跳转页面
  static void push(BuildContext context, Widget page) async {
    if (context == null || page == null) return;
    Navigator.push(
        context, new CupertinoPageRoute<void>(builder: (context) => page));
  }

  /// 跳转到 WebView 打开
  static void toWebView(BuildContext context, String title, String url) async {
    if (context == null || ObjectUtil.isEmpty(url)) return;
    if (url.endsWith('.apk')) {
      launchInBrowser(url, title: title);
    } else {
      Navigator.of(context)
          .push(new CupertinoPageRoute<void>(builder: (context) {
        return new WebViewScreen(
          title: title,
          url: url,
        );
      }));
    }
  }

  static Future<Null> launchInBrowser(String url, {String title}) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
