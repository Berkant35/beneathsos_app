import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/core/theme/app_theme.dart';
import 'package:beneathsos_app/features/field_test/presentation/mixins/scan_status_mixin.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/device_table.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Scanner state, device count and start/stop control.
class ScanStatusBar extends ConsumerWidget with ScanStatusMixin {
  /// Creates the bar.
  const ScanStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scanControllerProvider);
    final tracks = ref.watch(deviceTableProvider).tracks.values;
    final now = ref.watch(clockProvider)().millisecondsSinceEpoch;
    final controller = ref.read(scanControllerProvider.notifier);
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      child: Row(
        children: [
          Expanded(child: Text(statusLabel(l10n, state, tracks, now))),
          const SizedBox(width: AppSpacing.s),
          switch (state) {
            ScanRunning() => FilledButton.tonal(
              onPressed: controller.stop,
              child: Text(l10n.scanStop),
            ),
            ScanNeedsPermission(permanent: true) => FilledButton(
              onPressed: controller.openSettings,
              child: Text(l10n.actionOpenSettings),
            ),
            ScanNeedsPermission() => FilledButton(
              onPressed: controller.start,
              child: Text(l10n.actionGrantPermission),
            ),
            ScanIdle() || ScanBluetoothOff() || ScanFailed() => FilledButton(
              onPressed: controller.start,
              child: Text(l10n.scanStart),
            ),
          },
        ],
      ),
    );
  }
}
