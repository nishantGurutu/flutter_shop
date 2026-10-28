import 'package:flutter/material.dart';

class MiniWavePainter extends CustomPainter {
  final Color color;
  final List<dynamic> data;

  MiniWavePainter({required this.color, required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final minVal = data.reduce((a, b) => a < b ? a : b);
    final range = (maxVal - minVal) == 0 ? 1.0 : maxVal - minVal;

    double getY(double val) =>
        size.height -
        ((val - minVal) / range) * size.height * 0.75 -
        size.height * 0.1;

    final stepX = size.width / (data.length - 1);
    final path = Path();
    final fillPath = Path();

    path.moveTo(0, getY(data[0]));
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(0, getY(data[0]));

    for (int i = 1; i < data.length; i++) {
      final x = i * stepX;
      final y = getY(data[i]);
      final prevX = (i - 1) * stepX;
      final prevY = getY(data[i - 1]);
      final cpX = prevX + (x - prevX) / 2;
      path.cubicTo(cpX, prevY, cpX, y, x, y);
      fillPath.cubicTo(cpX, prevY, cpX, y, x, y);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.22), color.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant MiniWavePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.data != data;
}
