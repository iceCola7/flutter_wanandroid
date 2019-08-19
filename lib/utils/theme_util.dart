import 'package:flutter/material.dart';

class ThemeUtils {
  // 默认主题色
  static const Color defaultColor = Colors.redAccent;

  // 可选的主题色
  static const List<Color> supportColors = [
    const Color(0xFF5394FF),
    Colors.purple,
    Colors.orange,
    Colors.deepPurpleAccent,
    Colors.redAccent,
    Colors.blue,
    Colors.amber,
    Colors.green,
    Colors.lime,
    Colors.indigo,
    Colors.cyan,
    Colors.teal
  ];

  // 当前的主题色
  static Color currentColorTheme = defaultColor;

  static bool dark = false;

  static getThemeData(bool dark) {
    if (dark) {
      return themeDataDark;
    } else {
      return themeDataLight;
    }
  }

  static ThemeData themeData = getThemeData(dark);

  static ThemeData themeDataLight = new ThemeData(
      primaryColor: ThemeUtils.currentColorTheme, brightness: Brightness.light);

  static ThemeData themeDataDark = new ThemeData.dark();
}
