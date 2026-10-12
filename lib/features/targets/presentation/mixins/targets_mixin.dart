import 'package:beneathsos_app/features/targets/domain/candidates.dart';
import 'package:beneathsos_app/features/targets/domain/device_kind.dart';
import 'package:beneathsos_app/features/targets/domain/tracker_snapshot.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:rubble_core/rubble_core.dart';

/// Words for devices, their reasons and blocked scans; the candidate list.
mixin TargetsMixin {
  /// Devices heard now that may be the trapped phone, most promising first: not surface phones of
  /// [search], not already its targets.
  List<TargetCandidate> candidatesFor(
    TrackerSnapshot heard,
    SessionState? search,
  ) => rankCandidates(
    heard.devices,
    surface: search?.blacklist ?? const {},
    targets: {
      for (final t in search?.targets.values ?? const <TargetState>[])
        t.peripheralKey,
    },
  );

  /// What the device is, as far as its advertisement tells.
  String kindLabel(AppLocalizations l10n, DeviceKind kind) => switch (kind) {
    DeviceKind.appleFindMy => l10n.kindFindMy,
    DeviceKind.appleNearby || DeviceKind.appleOther => l10n.kindApple,
    DeviceKind.samsung => l10n.targetSamsung,
    DeviceKind.microsoft => l10n.kindWindows,
    DeviceKind.google => l10n.kindGoogle,
    DeviceKind.other => l10n.kindOther,
    DeviceKind.unknown => l10n.targetUnknown,
  };

  /// "Not moving · weak signal · not strong in the surface scan", "Heard only a few times so far ·
  /// weak signal", "Signal changing — it may be moving · …" or the very-strong advice. Never a
  /// distance (rule 2). [surfaceScanned] adds the surface-scan part.
  String reason(
    AppLocalizations l10n,
    TargetCandidate candidate, {
    required bool surfaceScanned,
  }) {
    if (candidate.strength == SignalStrength.veryStrong) {
      return l10n.reasonVeryStrong;
    }
    return [
      switch (candidate.movement) {
        Movement.still => l10n.reasonNotMoving,
        Movement.changing => l10n.reasonChanging,
        Movement.notKnownYet => l10n.reasonFewReadings,
      },
      if (candidate.strength == SignalStrength.weak)
        l10n.reasonWeak
      else
        l10n.reasonMedium,
      if (surfaceScanned) l10n.reasonNotOnSurface,
    ].join(' · ');
  }

  /// "Signal −78 dBm" (the measured signal; never a distance — rule 2).
  String signal(AppLocalizations l10n, TargetCandidate candidate) {
    final value =
        candidate.device.median?.value.round() ?? candidate.device.lastRssi;
    return l10n.targetSignal(value.toString().replaceFirst('-', '−'));
  }
}
