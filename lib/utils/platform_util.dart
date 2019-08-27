import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

/// Android IOS 平台工具类
class PlatformUtil {
  static String getPlatform() => Platform.operatingSystem;

  static bool isAndroid() => Platform.isAndroid;

  static bool isIOS() => Platform.isIOS;

  static String getFlutterVersion() => Platform.version;

  static Future<PackageInfo> getAppPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (isAndroid()) {
      return await deviceInfo.androidInfo;
    } else if (isIOS()) {
      return await deviceInfo.iosInfo;
    } else {
      return null;
    }
  }
}
