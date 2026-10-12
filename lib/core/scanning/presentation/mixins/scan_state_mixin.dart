import 'package:beneathsos_app/core/scanning/presentation/providers/scan_state.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';

/// Words for a scan that cannot run.
mixin ScanStateMixin {
  /// What to tell the rescuer while scanning cannot run.
  String blockedMessage(AppLocalizations l10n, ScanState scan) =>
      switch (scan) {
        ScanNeedsPermission(permanent: false) => l10n.readinessNeedsPermission,
        ScanNeedsPermission(permanent: true) =>
          l10n.readinessPermissionInSettings,
        ScanBluetoothOff() => l10n.readinessBluetoothOff,
        ScanFailed() => l10n.scanFailed,
        ScanIdle() || ScanRunning() => l10n.readinessChecking,
      };
}
