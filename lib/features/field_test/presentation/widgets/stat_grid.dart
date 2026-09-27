import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/theme/app_theme.dart';
import 'package:beneathsos_app/features/field_test/domain/device_track.dart';
import 'package:beneathsos_app/features/field_test/presentation/mixins/device_labels_mixin.dart';
import 'package:beneathsos_app/features/field_test/presentation/mixins/stat_grid_mixin.dart';
import 'package:flutter/material.dart';

/// Grid of RSSI statistics.
class StatGrid extends StatelessWidget with DeviceLabelsMixin, StatGridMixin {
  /// Creates the grid.
  const StatGrid({required this.track, required this.nowMillis, super.key});

  /// Track shown.
  final DeviceTrack track;

  /// Current wall-clock time.
  final int nowMillis;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Wrap(
      spacing: AppSpacing.m,
      runSpacing: AppSpacing.m,
      children: [
        for (final s in stats(context.l10n, track, nowMillis))
          SizedBox(
            width: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.label, style: text.labelMedium),
                Text(s.value, style: text.titleLarge),
              ],
            ),
          ),
      ],
    );
  }
}
