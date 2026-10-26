import 'dart:math' as math;
import 'package:flutter/material.dart';

// ── Donut Chart Painter ───────────────────────────────────────────────────
class DonutChartPainter extends CustomPainter {
  final List<_Segment> segments;

  DonutChartPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    const strokeW = 36.0;
    double startAngle = -math.pi / 2;

    final total = segments.fold<double>(0, (s, e) => s + e.value);

    for (final seg in segments) {
      final sweep = (seg.value / total) * 2 * math.pi;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep - 0.03,
        false,
        Paint()
          ..color = seg.color
          ..strokeWidth = strokeW
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.butt,
      );
      startAngle += sweep;
    }

    // Centre text
    final total1248 = TextPainter(
      text: const TextSpan(
        children: [
          TextSpan(
              text: 'Total\n',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.normal)),
          TextSpan(
              text: '1,248',
              style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    total1248.paint(
        canvas,
        Offset(center.dx - total1248.width / 2,
            center.dy - total1248.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Segment {
  final Color color;
  final double value;
  const _Segment(this.color, this.value);
}

// ── Order Status Widget ───────────────────────────────────────────────────
class OrderStatusSection extends StatelessWidget {
  const OrderStatusSection({super.key});

  static const _segments = [
    _Segment(Color(0xFF2E7D32), 896),
    _Segment(Color(0xFF1565C0), 186),
    _Segment(Color(0xFFF9A825), 98),
    _Segment(Color(0xFFBDBDBD), 68),
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
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Status',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A))),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: CustomPaint(
                    painter: DonutChartPainter(segments: _segments)),
              ),
              const SizedBox(width: 24),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LegendRow(
                        color: Color(0xFF2E7D32),
                        label: 'Delivered',
                        count: '896',
                        percent: '71.8%'),
                    SizedBox(height: 10),
                    _LegendRow(
                        color: Color(0xFF1565C0),
                        label: 'Processing',
                        count: '186',
                        percent: '14.9%'),
                    SizedBox(height: 10),
                    _LegendRow(
                        color: Color(0xFFF9A825),
                        label: 'Shipped',
                        count: '98',
                        percent: '7.9%'),
                    SizedBox(height: 10),
                    _LegendRow(
                        color: Color(0xFFBDBDBD),
                        label: 'Cancelled',
                        count: '68',
                        percent: '5.4%'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Text('View All Orders',
                    style: TextStyle(
                        color: Color(0xFF2E7D32), fontSize: 13)),
                label: const Icon(Icons.arrow_forward,
                    size: 14, color: Color(0xFF2E7D32)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String count;
  final String percent;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.count,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 10,
            height: 10,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.grey))),
        Text('$count ',
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold)),
        Text('($percent)',
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
