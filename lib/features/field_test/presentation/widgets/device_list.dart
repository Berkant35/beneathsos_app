import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/features/field_test/presentation/mixins/device_list_mixin.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/device_table.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/field_test_filter.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/target_selection.dart';
import 'package:beneathsos_app/features/field_test/presentation/widgets/device_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Filtered, sorted list of advertisers.
class DeviceList extends ConsumerWidget with DeviceListMixin {
  /// Creates the list.
  const DeviceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final table = ref.watch(deviceTableProvider);
    final filter = ref.watch(fieldTestFilterProvider);
    final targets = ref.watch(targetSelectionProvider);
    ref.watch(secondTickerProvider);
    final now = ref.watch(clockProvider)().millisecondsSinceEpoch;
    final tracks = visibleTracks(table.tracks.values, filter, targets);
    if (tracks.isEmpty) return Center(child: Text(context.l10n.emptyDevices));
    return ListView.builder(
      itemCount: tracks.length,
      itemBuilder: (context, i) {
        final track = tracks[i];
        return DeviceListTile(
          track: track,
          isTarget: targets.contains(track.key),
          nowMillis: now,
          onTap: () => DeviceDetailRoute(deviceKey: track.key).go(context),
          onToggleTarget: () =>
              ref.read(targetSelectionProvider.notifier).toggle(track.key),
        );
      },
    );
  }
}
