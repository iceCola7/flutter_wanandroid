import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_wanandroid/res/dimens.dart';
import 'package:flutter_wanandroid/utils/theme_util.dart';

class Decorations {
  static Decoration bottom = new BoxDecoration(
    border: new Border(
      bottom: BorderSide(
        width: 0.5,
        color: ThemeUtils.getThemeData().dividerColor,
      ),
    ),
  );
}

/// 间隔
class Gaps {
  /// 水平间隔
  static Widget hGap5 = new SizedBox(width: Dimens.gap_dp5);
  static Widget hGap10 = new SizedBox(width: Dimens.gap_dp10);
  static Widget hGap15 = new SizedBox(width: Dimens.gap_dp15);

  /// 垂直间隔
  static Widget vGap5 = new SizedBox(height: Dimens.gap_dp5);
  static Widget vGap10 = new SizedBox(height: Dimens.gap_dp10);
  static Widget vGap15 = new SizedBox(height: Dimens.gap_dp15);
}
