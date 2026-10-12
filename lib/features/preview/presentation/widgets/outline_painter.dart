import 'dart:ui' show PointMode;

import 'package:flutter/material.dart';

/// Preview of the rubble outline on a metric grid, with edge lengths (sample data).
/// The real drawing canvas comes with `rubble_canvas` (roadmap phase 5).
class OutlinePainter extends CustomPainter {
  /// Creates the painter; [lengths] are the four edge labels, already formatted.
  const OutlinePainter({
    required this.grid,
    required this.outline,
    required this.label,
    required this.lengths,
  });

  /// Grid colour.
  final Color grid;

  /// Outline colour.
  final Color outline;

  /// Label style.
  final TextStyle label;

  /// Edge labels, clockwise from the top edge.
  final List<String> lengths;

  static const _corners = [
    Offset(0.24, 0.22),
    Offset(0.78, 0.18),
    Offset(0.82, 0.74),
    Offset(0.28, 0.8),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var i = 1; i < 10; i++) {
      final x = size.width * i / 10;
      final y = size.height * i / 10;
      canvas
        ..drawLine(Offset(x, 0), Offset(x, size.height), gridPaint)
        ..drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    final points = [
      for (final c in _corners) Offset(c.dx * size.width, c.dy * size.height),
    ];
    canvas
      ..drawPath(
        Path()..addPolygon(points, true),
        Paint()
          ..color = outline
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      )
      ..drawPoints(
        PointMode.points,
        points,
        Paint()
          ..color = outline
          ..strokeWidth = 14
          ..strokeCap = StrokeCap.round,
      );
    final centroid = points.reduce((a, b) => a + b) / points.length.toDouble();
    for (var i = 0; i < points.length; i++) {
      final mid = (points[i] + points[(i + 1) % points.length]) / 2;
      final outward = mid - centroid;
      final anchor = mid + outward / outward.distance * 22;
      final painter = TextPainter(
        text: TextSpan(text: lengths[i], style: label),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        anchor - Offset(painter.width / 2, painter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(OutlinePainter oldDelegate) =>
      oldDelegate.grid != grid ||
      oldDelegate.outline != outline ||
      oldDelegate.lengths != lengths;
}
