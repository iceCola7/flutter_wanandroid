import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/res/styles.dart';
import 'package:flutter_wanandroid/utils/utils.dart';

/// 扫码下载页面
class QrCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        title: Text("扫码下载"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Text(
              "好用的话推荐给你的小伙伴吧",
              style: TextStyle(fontSize: 14),
            ),
            Gaps.vGap5,
            Text(
              "（ 建议使用浏览器扫描二维码下载 ^_^ ）",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 60),
            Image.asset(
              Utils.getImgPath('qr_code'),
              width: 260.0,
              fit: BoxFit.fill,
              height: 260.0,
            )
          ],
        ),
      ),
    );
  }
}
