import 'package:beneathsos_app/features/field_test/domain/device_kind.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';

/// Shared label formatting for device widgets.
mixin DeviceLabelsMixin {
  /// Localised name of [kind].
  String kindLabel(AppLocalizations l10n, DeviceKind kind) => switch (kind) {
    DeviceKind.appleFindMy => l10n.kindAppleFindMy,
    DeviceKind.appleNearby => l10n.kindAppleNearby,
    DeviceKind.appleOther => l10n.kindAppleOther,
    DeviceKind.samsung => l10n.kindSamsung,
    DeviceKind.microsoft => l10n.kindMicrosoft,
    DeviceKind.google => l10n.kindGoogle,
    DeviceKind.other => l10n.kindOther,
    DeviceKind.unknown => l10n.kindUnknown,
  };

  /// `-71 dBm` or a dash.
  String rssiLabel(AppLocalizations l10n, num? value) =>
      value == null ? l10n.noValue : l10n.rssiValue(value.round());

  /// Last 8 characters of an identity — enough to tell devices apart on screen.
  String shortKey(String key) =>
      key.length <= 8 ? key : '…${key.substring(key.length - 8)}';

  /// `mm:ss` for [elapsed].
  String clockLabel(Duration elapsed) {
    final m = elapsed.inMinutes.toString().padLeft(2, '0');
    final s = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
