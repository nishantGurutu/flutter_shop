import 'dart:math' as math;
import 'package:flutter/material.dart';

class SalesChartPainter extends CustomPainter {
  final List<double> thisWeek;
  final List<double> lastWeek;

  SalesChartPainter({required this.thisWeek, required this.lastWeek});

  @override
  void paint(Canvas canvas, Size size) {
    final allValues = [...thisWeek, ...lastWeek];
    final maxVal = allValues.reduce(math.max);
    final paddingLeft = 50.0;
    final paddingBottom = 30.0;
    final chartW = size.width - paddingLeft;
    final chartH = size.height - paddingBottom;

    double getX(int i, int total) => paddingLeft + (i / (total - 1)) * chartW;
    double getY(double val) => chartH - (val / maxVal) * chartH * 0.85;

    // Grid lines + Y labels
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;
    final textStyle = const TextStyle(color: Colors.grey, fontSize: 10);

    final ySteps = [0, 20000, 40000, 60000, 80000];
    for (final y in ySteps) {
      final dy = getY(y.toDouble());
      canvas.drawLine(
        Offset(paddingLeft, dy),
        Offset(size.width, dy),
        gridPaint,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: y == 0 ? '₹0' : '₹${y ~/ 1000}K',
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, dy - 6));
    }

    // X labels
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (int i = 0; i < days.length; i++) {
      final tp = TextPainter(
        text: TextSpan(text: days[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(getX(i, days.length) - tp.width / 2, size.height - 20),
      );
    }

    // Last Week dashed line
    _drawDashedLine(canvas, lastWeek, getX, getY, Colors.grey.shade400);

    // This Week fill
    final fillPath = Path();
    fillPath.moveTo(getX(0, thisWeek.length), chartH);
    fillPath.lineTo(getX(0, thisWeek.length), getY(thisWeek[0]));
    for (int i = 1; i < thisWeek.length; i++) {
      final px = getX(i - 1, thisWeek.length);
      final cx = getX(i, thisWeek.length);
      final py = getY(thisWeek[i - 1]);
      final cy = getY(thisWeek[i]);
      final mid = px + (cx - px) / 2;
      fillPath.cubicTo(mid, py, mid, cy, cx, cy);
    }
    fillPath.lineTo(getX(thisWeek.length - 1, thisWeek.length), chartH);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2E7D32).withOpacity(0.20),
            const Color(0xFF2E7D32).withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill,
    );

    // This Week solid line
    _drawSmoothLine(
      canvas,
      thisWeek,
      getX,
      getY,
      const Color(0xFF2E7D32),
      false,
    );
  }

  void _drawSmoothLine(
    Canvas canvas,
    List<double> data,
    double Function(int, int) getX,
    double Function(double) getY,
    Color color,
    bool dashed,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(getX(0, data.length), getY(data[0]));
    for (int i = 1; i < data.length; i++) {
      final px = getX(i - 1, data.length);
      final cx = getX(i, data.length);
      final py = getY(data[i - 1]);
      final cy = getY(data[i]);
      final mid = px + (cx - px) / 2;
      path.cubicTo(mid, py, mid, cy, cx, cy);
    }
    canvas.drawPath(path, paint);

    // Dots on this week line
    if (!dashed) {
      final dotPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      for (int i = 0; i < data.length; i++) {
        canvas.drawCircle(
          Offset(getX(i, data.length), getY(data[i])),
          4,
          dotPaint,
        );
        canvas.drawCircle(
          Offset(getX(i, data.length), getY(data[i])),
          4,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
    }
  }

  void _drawDashedLine(
    Canvas canvas,
    List<double> data,
    double Function(int, int) getX,
    double Function(double) getY,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < data.length - 1; i++) {
      final x1 = getX(i, data.length);
      final y1 = getY(data[i]);
      final x2 = getX(i + 1, data.length);
      final y2 = getY(data[i + 1]);
      _drawDash(canvas, Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  void _drawDash(Canvas canvas, Offset start, Offset end, Paint paint) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final len = math.sqrt(dx * dx + dy * dy);
    const dashLen = 6.0;
    const gapLen = 4.0;
    final steps = (len / (dashLen + gapLen)).floor();
    for (int i = 0; i < steps; i++) {
      final t1 = i * (dashLen + gapLen) / len;
      final t2 = (i * (dashLen + gapLen) + dashLen) / len;
      canvas.drawLine(
        Offset(start.dx + dx * t1, start.dy + dy * t1),
        Offset(
          start.dx + dx * math.min(t2, 1.0),
          start.dy + dy * math.min(t2, 1.0),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ── Sales Overview Widget ─────────────────────────────────────────────────
class SalesOverviewSection extends StatelessWidget {
  const SalesOverviewSection({super.key});

  static const List<double> _thisWeek = [
    5000.0,
    25000.0,
    32000.0,
    62000.0,
    48000.0,
    55000.0,
    52000.0,
  ];
  static const List<double> _lastWeek = [
    8000.0,
    18000.0,
    28000.0,
    38000.0,
    30000.0,
    20000.0,
    15000.0,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sales Overview',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Row(
                children: [
                  _legendDot(const Color(0xFF2E7D32), 'This Week'),
                  const SizedBox(width: 16),
                  _legendDot(Colors.grey.shade400, 'Last Week'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: CustomPaint(
              painter: SalesChartPainter(
                thisWeek: _thisWeek,
                lastWeek: _lastWeek,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
