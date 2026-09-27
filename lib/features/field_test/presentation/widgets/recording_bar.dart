import 'dart:async';

import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/core/theme/app_theme.dart';
import 'package:beneathsos_app/features/field_test/presentation/mixins/device_labels_mixin.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/recording_controller.dart';
import 'package:beneathsos_app/features/field_test/presentation/widgets/marker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// CSV recording controls: record/stop, marker, share.
class RecordingBar extends ConsumerWidget with DeviceLabelsMixin {
  /// Creates the bar.
  const RecordingBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordingControllerProvider);
    ref.watch(secondTickerProvider);
    final now = ref.watch(clockProvider)();
    final controller = ref.read(recordingControllerProvider.notifier);
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      child: Wrap(
        spacing: AppSpacing.s,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          switch (state) {
            RecordingOn(:final samples, :final since) => FilledButton.icon(
              onPressed: controller.stop,
              icon: const Icon(Icons.stop),
              label: Text(
                l10n.recordRunning(samples, clockLabel(now.difference(since))),
              ),
            ),
            RecordingOff() => OutlinedButton.icon(
              onPressed: controller.start,
              icon: const Icon(Icons.fiber_manual_record),
              label: Text(l10n.recordStart),
            ),
          },
          if (state is RecordingOn)
            IconButton(
              tooltip: l10n.markerAdd,
              icon: const Icon(Icons.flag),
              onPressed: () => unawaited(_addMarker(context, controller)),
            ),
          if (state.lastFile != null && state is RecordingOff)
            IconButton(
              tooltip: l10n.recordShare,
              icon: const Icon(Icons.ios_share),
              onPressed: controller.shareLast,
            ),
        ],
      ),
    );
  }

  Future<void> _addMarker(
    BuildContext context,
    RecordingController controller,
  ) async {
    final text = await MarkerDialog.show(context);
    if (text == null || text.isEmpty) return;
    controller.addMarker(text);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.markerSaved)));
  }
}
