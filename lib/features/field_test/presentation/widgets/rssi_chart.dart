import 'package:beneathsos_app/features/field_test/domain/device_track.dart';
import 'package:beneathsos_app/features/field_test/presentation/widgets/rssi_chart_painter.dart';
import 'package:flutter/material.dart';

/// Live RSSI chart of one track (last 60 s).
class RssiChart extends StatelessWidget {
  /// Creates the chart.
  const RssiChart({required this.track, required this.nowMillis, super.key});

  /// Track shown.
  final DeviceTrack track;

  /// Current wall-clock time.
  final int nowMillis;

  static const double _height = 220;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: _height,
      child: CustomPaint(
        painter: RssiChartPainter(
          points: track.readings.toList(),
          nowMillis: nowMillis,
          lineColor: scheme.primary,
          dotColor: scheme.onSurfaceVariant.withValues(alpha: 0.5),
          gridColor: scheme.outlineVariant,
        ),
      ),
    );
  }
}
