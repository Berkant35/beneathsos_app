import 'package:flutter/material.dart';

/// Preview of the probability map: outline, placeholder heat, 50 % and 90 % regions, measured
/// points and the suggested next point (sample data). The real map comes in roadmap phase 9.
class ProbabilityPainter extends CustomPainter {
  /// Creates the painter.
  const ProbabilityPainter({
    required this.outline,
    required this.grid,
    required this.label,
    required this.background,
    required this.mostLikely,
    required this.region90,
    required this.noSignal,
  });

  /// Outline, regions and points.
  final Color outline;

  /// Rubble fill.
  final Color grid;

  /// Label style.
  final TextStyle label;

  /// Label background.
  final Color background;

  /// "Most likely area · 50 %" label.
  final String mostLikely;

  /// "90 %" label.
  final String region90;

  /// "no signal" label.
  final String noSignal;

  @override
  void paint(Canvas canvas, Size size) {
    Offset at(double x, double y) => Offset(x * size.width, y * size.height);
    final rubble = Path()
      ..addPolygon([
        at(0.08, 0.1),
        at(0.92, 0.08),
        at(0.95, 0.9),
        at(0.1, 0.92),
      ], true);
    final centre = at(0.58, 0.48);
    final radius = size.shortestSide * 0.4;
    canvas
      ..drawPath(rubble, Paint()..color = grid.withValues(alpha: 0.35))
      ..drawCircle(
        centre,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              outline.withValues(alpha: 0.45),
              outline.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: centre, radius: radius)),
      );
    final region = Paint()
      ..style = PaintingStyle.stroke
      ..color = outline;
    final ninety = Rect.fromCenter(
      center: centre,
      width: size.width * 0.55,
      height: size.height * 0.5,
    );
    final fifty = Rect.fromCenter(
      center: centre,
      width: size.width * 0.28,
      height: size.height * 0.24,
    );
    canvas
      ..drawOval(ninety, region..strokeWidth = 2)
      ..drawOval(fifty, region..strokeWidth = 4)
      ..drawPath(
        rubble,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = outline,
      );
    _text(canvas, mostLikely, fifty.bottomCenter + const Offset(0, 18));
    _text(canvas, region90, ninety.topCenter + const Offset(0, 18));
    final heard = Paint()..color = outline;
    final open = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = outline;
    for (final (point, dbm) in [
      (at(0.2, 0.18), '−84 dBm'),
      (at(0.8, 0.16), '−73 dBm'),
      (at(0.82, 0.82), '−70 dBm'),
    ]) {
      canvas.drawCircle(point, 9, heard);
      _text(canvas, dbm, point + const Offset(0, 26));
    }
    final quiet = at(0.2, 0.8);
    canvas.drawCircle(quiet, 9, open);
    _text(canvas, noSignal, quiet + const Offset(0, 26));
    final next = at(0.5, 0.82);
    canvas
      ..drawCircle(next, 13, open)
      ..drawLine(next - const Offset(7, 0), next + const Offset(7, 0), open)
      ..drawLine(next - const Offset(0, 7), next + const Offset(0, 7), open);
  }

  /// A centred label with a small background so it stays readable over lines and heat.
  void _text(Canvas canvas, String value, Offset centre) {
    final painter = TextPainter(
      text: TextSpan(text: value, style: label),
      textDirection: TextDirection.ltr,
    )..layout();
    final origin = centre - Offset(painter.width / 2, painter.height / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        (origin & painter.size).inflate(3),
        const Radius.circular(4),
      ),
      Paint()..color = background,
    );
    painter.paint(canvas, origin);
  }

  @override
  bool shouldRepaint(ProbabilityPainter oldDelegate) =>
      oldDelegate.outline != outline || oldDelegate.mostLikely != mostLikely;
}
