import 'package:flutter/services.dart';

class VersionUtil {
  static const MethodChannel _channel = const MethodChannel('version');

  static void install(String path) {
    _channel.invokeMethod("install", {'path': path});
  }

  static void jumpAppStore() {
    _channel.invokeMethod("jumpAppStore");
  }
}
