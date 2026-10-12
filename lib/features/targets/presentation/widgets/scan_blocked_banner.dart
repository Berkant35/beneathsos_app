import 'dart:async';

import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_controller.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_state.dart';
import 'package:beneathsos_app/features/targets/presentation/mixins/targets_mixin.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Why the scan cannot run, and the tap that fixes it (ask again, open Settings, try again).
class ScanBlockedBanner extends ConsumerWidget with TargetsMixin {
  /// Creates the banner for [scan].
  const ScanBlockedBanner({required this.scan, super.key});

  /// The blocked scan.
  final ScanState scan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(scanControllerProvider.notifier);
    return StatusBanner(
      kind: scan is ScanBluetoothOff
          ? StatusKind.blocked
          : StatusKind.attention,
      message: blockedMessage(context.l10n, scan),
      // Errors are shown by the scan state itself.
      onTap: switch (scan) {
        ScanNeedsPermission(permanent: true) => () => unawaited(
          controller.openSettings(),
        ),
        ScanNeedsPermission() ||
        ScanFailed() => () => unawaited(controller.start()),
        _ => null,
      },
    );
  }
}
