import 'package:beneathsos_app/features/field_test/domain/rssi_point.dart';
import 'package:flutter/material.dart';

/// Draws RSSI readings of the last [span] as dots plus a 5 s rolling median line.
class RssiChartPainter extends CustomPainter {
  /// Creates the painter.
  RssiChartPainter({
    required this.points,
    required this.nowMillis,
    required this.lineColor,
    required this.dotColor,
    required this.gridColor,
    this.span = const Duration(seconds: 60),
  });

  /// Readings, oldest first.
  final List<RssiPoint> points;

  /// Right edge of the chart.
  final int nowMillis;

  /// Median line colour.
  final Color lineColor;

  /// Reading dot colour.
  final Color dotColor;

  /// Grid colour.
  final Color gridColor;

  /// Visible time span.
  final Duration span;

  /// Vertical range in dBm.
  static const double minDbm = -105;

  /// Vertical range in dBm.
  static const double maxDbm = -30;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var dbm = -100; dbm <= -40; dbm += 20) {
      final y = _y(dbm.toDouble(), size);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final from = nowMillis - span.inMilliseconds;
    final visible = [
      for (final p in points)
        if (p.atMillis >= from) p,
    ];
    final dot = Paint()..color = dotColor;
    for (final p in visible) {
      canvas.drawCircle(
        Offset(_x(p.atMillis, from, size), _y(p.rssi.toDouble(), size)),
        1.8,
        dot,
      );
    }
    final path = Path();
    var started = false;
    for (var i = 0; i < visible.length; i += 3) {
      final t = visible[i].atMillis;
      final window = [
        for (final p in visible)
          if (p.atMillis > t - 5000 && p.atMillis <= t) p.rssi,
      ]..sort();
      final offset = Offset(
        _x(t, from, size),
        _y(window[window.length ~/ 2].toDouble(), size),
      );
      started
          ? path.lineTo(offset.dx, offset.dy)
          : path.moveTo(offset.dx, offset.dy);
      started = true;
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );
  }

  double _x(int atMillis, int from, Size size) =>
      (atMillis - from) / span.inMilliseconds * size.width;

  double _y(double dbm, Size size) =>
      (1 - ((dbm.clamp(minDbm, maxDbm) - minDbm) / (maxDbm - minDbm))) *
      size.height;

  @override
  bool shouldRepaint(RssiChartPainter old) =>
      old.nowMillis != nowMillis || old.points.length != points.length;
}
