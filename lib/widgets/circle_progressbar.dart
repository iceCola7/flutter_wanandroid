import 'dart:math';

import 'package:flutter/material.dart';

class CircleProgressBarPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Color fillColor;

  const CircleProgressBarPainter(
      {this.progress = 0,
      this.strokeWidth = 3,
      this.color = Colors.grey,
      this.fillColor = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint()
      ..color = this.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final double diam = min(size.width, size.height);
    final centerX = size.width * 0.5;
    final centerY = size.height * 0.5;
    final radius = diam / 2.0;

    canvas.drawCircle(Offset(centerX, centerY), radius, paint);
    paint.color = this.fillColor;
    // draw in center
    var rect = Rect.fromLTWH((size.width - diam) * 0.5, 0, diam, diam);
    canvas.drawArc(rect, -0.5 * pi, progress * 2 * pi, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
