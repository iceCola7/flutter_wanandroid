import 'dart:math';
import 'dart:ui';

import 'package:flutter_wanandroid/utils/theme_util.dart';

class CommonUtil {
  /// 随机获取颜色
  static Color randomColor() {
    Random random = Random();
    int r = 0;
    int g = 0;
    int b = 0;
    bool dark = ThemeUtils.dark; // 是否是夜间模式
    if (!dark) {
      // 0-190, 如果颜色值过大,就越接近白色,就看不清了,所以需要限定范围
      r = random.nextInt(190);
      g = random.nextInt(190);
      b = random.nextInt(190);
    } else {
      // 150-255
      r = random.nextInt(105) + 150;
      g = random.nextInt(105) + 150;
      b = random.nextInt(105) + 150;
    }
    return Color.fromARGB(255, r, g, b);
  }
}
