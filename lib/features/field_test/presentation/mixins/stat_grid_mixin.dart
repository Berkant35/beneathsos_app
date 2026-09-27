import 'package:beneathsos_app/features/field_test/domain/device_track.dart';
import 'package:beneathsos_app/features/field_test/presentation/mixins/device_labels_mixin.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';

/// A labelled statistic.
typedef StatEntry = ({String label, String value});

/// Builds the statistic list shown for a track.
mixin StatGridMixin on DeviceLabelsMixin {
  /// Statistics for [track] at [nowMillis].
  List<StatEntry> stats(
    AppLocalizations l10n,
    DeviceTrack track,
    int nowMillis,
  ) {
    const s5 = Duration(seconds: 5);
    const s15 = Duration(seconds: 15);
    final sd = track.stdDevWithin(s15, nowMillis);
    return [
      (label: l10n.statNow, value: rssiLabel(l10n, track.lastRssi)),
      (
        label: l10n.statMedian5,
        value: rssiLabel(l10n, track.medianWithin(s5, nowMillis)),
      ),
      (
        label: l10n.statMedian15,
        value: rssiLabel(l10n, track.medianWithin(s15, nowMillis)),
      ),
      (
        label: l10n.statStdDev15,
        value: sd == null ? l10n.noValue : sd.toStringAsFixed(1),
      ),
      (
        label: l10n.statRate,
        value: track.rateWithin(s5, nowMillis).toStringAsFixed(1),
      ),
      (label: l10n.statCount, value: '${track.sampleCount}'),
    ];
  }
}
