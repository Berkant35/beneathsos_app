import 'dart:async';

import 'package:beneathsos_app/core/readiness/domain/device_readiness.dart';
import 'package:beneathsos_app/core/readiness/presentation/providers/readiness_controller.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// What the readiness banner shows.
typedef BannerContent = ({
  StatusKind kind,
  String message,
  IconData? icon,
  VoidCallback? onTap,
});

/// Maps device readiness to the home banner: what happened, what to do, and the tap action.
mixin ReadinessBannerMixin {
  /// Banner content for [readiness]; actions go to [controller].
  BannerContent bannerFor(
    AppLocalizations l10n,
    DeviceReadiness readiness,
    ReadinessController controller,
  ) => switch (readiness) {
    ReadinessChecking() => (
      kind: StatusKind.ready,
      message: l10n.readinessChecking,
      icon: Icons.hourglass_top_rounded,
      onTap: null,
    ),
    ReadinessReady() => (
      kind: StatusKind.ready,
      message: l10n.readinessReady,
      icon: null,
      onTap: null,
    ),
    ReadinessNeedsPermission() => (
      kind: StatusKind.blocked,
      message: l10n.readinessNeedsPermission,
      icon: null,
      onTap: () => unawaited(controller.requestPermission()),
    ),
    ReadinessPermissionInSettings() => (
      kind: StatusKind.blocked,
      message: l10n.readinessPermissionInSettings,
      icon: null,
      onTap: () => unawaited(controller.openSettings()),
    ),
    // iOS does not let apps switch Bluetooth on: instruction only.
    ReadinessBluetoothOff() => (
      kind: StatusKind.blocked,
      message: l10n.readinessBluetoothOff,
      icon: null,
      onTap: null,
    ),
    ReadinessFailed() => (
      kind: StatusKind.blocked,
      message: l10n.readinessFailed,
      icon: null,
      onTap: () => unawaited(controller.recheck()),
    ),
    ReadinessUnsupported() => (
      kind: StatusKind.blocked,
      message: l10n.readinessUnsupported,
      icon: null,
      onTap: null,
    ),
  };
}
