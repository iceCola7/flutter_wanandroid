import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

/// 屏幕工具类
class ScreenAdapter {
  static init(context) {
    ScreenUtil.instance = ScreenUtil(width: 720, height: 1280)..init(context);
  }

  static height(double value) {
    return ScreenUtil.getInstance().setHeight(value);
  }

  static width(double value) {
    return ScreenUtil.getInstance().setWidth(value);
  }

  static size(double value) {
    if (Platform.isAndroid) {
      return value;
    }
    return ScreenUtil.getInstance().setWidth(2 * value);
  }

  static getScreenHeight() {
    return ScreenUtil.screenHeightDp;
  }

  static getScreenWidth() {
    return ScreenUtil.screenWidthDp;
  }

  static fontSize(double fontSize) {
    if (Platform.isAndroid) {
      return fontSize;
    }
    return ScreenUtil.getInstance().setSp(2 * fontSize);
  }
}
