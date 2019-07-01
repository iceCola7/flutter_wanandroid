import 'dart:math';
import 'dart:ui';

class CommonUtil {
  /// 随机获取颜色
  static Color randomColor() {
    Random random = Random();
    int r = random.nextInt(190);
    int g = random.nextInt(190);
    int b = random.nextInt(190);
    return Color.fromARGB(255, r, g, b);
  }
}
