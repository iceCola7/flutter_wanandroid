import 'dart:ui' as ui; //这里用as取个别名，有库名冲突

import 'package:flutter/material.dart';

/// TODO
class TiltTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TiltText(),
    );
  }
}

class TiltText extends CustomPainter {
  /// 画笔
  Paint mPaint;
  Paint mTextPaint;

  @override
  void paint(Canvas canvas, Size size) {
    mPaint = new Paint()
      ..color = Colors.red
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    print(size);

    /// 画背景
    drawBg(canvas, size);

    /// 绘制文字
    drawText(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  /// 画背景
  void drawBg(Canvas canvas, Size size) {
    Path path = new Path();
    double w = size.width;
    double h = size.height;
    path.lineTo(w, 0);
    path.lineTo(w, h);
    path.close();
    canvas.drawPath(path, mPaint);
    // canvas.save();
  }

  /// 绘制文字
  void drawText(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.left,
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
      fontSize: 6,
    ));
    pb.pushStyle(ui.TextStyle(color: Colors.white));
    pb.addText('重要');
    // 设置文本的宽度约束
    ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: 30);
    // 这里需要先layout,将宽度约束填入，否则无法绘制
    ui.Paragraph paragraph = pb.build()..layout(pc);

    // canvas.rotate(pi / 8);

    // 文字左上角起始点
    Offset offset = Offset(w / 2, h / 4);
    canvas.drawParagraph(paragraph, offset);
  }

  void calculateXY(Canvas canvas, int w, int h) {}
}
