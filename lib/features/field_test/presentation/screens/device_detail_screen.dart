import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/core/theme/app_theme.dart';
import 'package:beneathsos_app/core/widgets/app_scaffold.dart';
import 'package:beneathsos_app/features/field_test/presentation/mixins/device_labels_mixin.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/device_table.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/target_selection.dart';
import 'package:beneathsos_app/features/field_test/presentation/widgets/identity_timer_card.dart';
import 'package:beneathsos_app/features/field_test/presentation/widgets/payload_card.dart';
import 'package:beneathsos_app/features/field_test/presentation/widgets/relink_suggestions.dart';
import 'package:beneathsos_app/features/field_test/presentation/widgets/rssi_chart.dart';
import 'package:beneathsos_app/features/field_test/presentation/widgets/stat_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Live view of one advertiser: identity timer, RSSI chart, statistics, relink hints.
class DeviceDetailScreen extends ConsumerWidget with DeviceLabelsMixin {
  /// Creates the screen for [deviceKey].
  const DeviceDetailScreen({required this.deviceKey, super.key});

  /// Identity shown.
  final String deviceKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = ref.watch(
      deviceTableProvider.select((t) => t.tracks[deviceKey]),
    );
    ref.watch(deviceTableProvider.select((t) => t.version));
    ref.watch(secondTickerProvider);
    final now = ref.watch(clockProvider)().millisecondsSinceEpoch;
    final isTarget = ref.watch(targetSelectionProvider).contains(deviceKey);
    final l10n = context.l10n;
    if (track == null) {
      return AppScaffold(
        title: shortKey(deviceKey),
        body: Center(child: Text(l10n.emptyDevices)),
      );
    }
    return AppScaffold(
      title: '${kindLabel(l10n, track.kind)} · ${shortKey(deviceKey)}',
      body: ListView(
        children: [
          IdentityTimerCard(track: track, nowMillis: now),
          const SizedBox(height: AppSpacing.m),
          RssiChart(track: track, nowMillis: now),
          const SizedBox(height: AppSpacing.m),
          StatGrid(track: track, nowMillis: now),
          const SizedBox(height: AppSpacing.m),
          FilledButton.tonalIcon(
            onPressed: () =>
                ref.read(targetSelectionProvider.notifier).toggle(deviceKey),
            icon: Icon(isTarget ? Icons.star : Icons.star_border),
            label: Text(isTarget ? l10n.targetUnset : l10n.targetSet),
          ),
          if (isTarget) RelinkSuggestions(targetKey: deviceKey),
          PayloadCard(track: track),
          const SizedBox(height: AppSpacing.m),
          Text(l10n.disclaimer, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
