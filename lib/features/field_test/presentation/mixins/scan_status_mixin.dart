import 'package:beneathsos_app/features/field_test/domain/device_track.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/scan_controller.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';

/// Status text for the scanner bar.
mixin ScanStatusMixin {
  /// One-line description of [state].
  String statusLabel(
    AppLocalizations l10n,
    ScanState state,
    Iterable<DeviceTrack> tracks,
    int nowMillis,
  ) => switch (state) {
    ScanIdle() => l10n.scanStateIdle,
    ScanNeedsPermission() => l10n.scanStateNeedsPermission,
    ScanBluetoothOff() => l10n.scanStateBluetoothOff,
    ScanFailed(:final reason) => l10n.scanStateFailed(reason),
    ScanRunning() => l10n.scanStateRunning(
      tracks.length,
      tracks
          .fold<double>(
            0,
            (sum, t) =>
                sum + t.rateWithin(const Duration(seconds: 5), nowMillis),
          )
          .round(),
    ),
  };
}
