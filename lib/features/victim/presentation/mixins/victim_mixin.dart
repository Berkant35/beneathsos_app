import 'package:beneathsos_app/features/victim/domain/victim_state.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';

/// The words of victim mode.
mixin VictimMixin {
  /// The headline for [state].
  String headline(AppLocalizations l10n, VictimState state) => switch (state) {
    VictimStarting() => l10n.victimStarting,
    VictimCallingOut() => l10n.victimSending,
    VictimNeedsPermission(permanently: false) => l10n.victimNeedsPermission,
    VictimNeedsPermission(permanently: true) => l10n.victimNeedsSettings,
    VictimBluetoothOff() => l10n.victimBluetoothOff,
    VictimUnsupported() => l10n.victimUnsupported,
    VictimFailed() => l10n.victimFailed,
  };

  /// What rescuers receive: the signal name and, when known, the battery.
  List<String> details(AppLocalizations l10n, VictimCallingOut state) => [
    l10n.victimSignalName(state.payload.localName),
    if (state.payload.batteryPercent case final percent?)
      l10n.victimBatteryValue(percent),
  ];

  /// The action that can fix [state], if any.
  String? actionLabel(AppLocalizations l10n, VictimState state) =>
      switch (state) {
        VictimNeedsPermission(permanently: false) => l10n.victimAllow,
        VictimNeedsPermission(permanently: true) => l10n.victimOpenSettings,
        VictimFailed() => l10n.victimRetry,
        _ => null,
      };
}
