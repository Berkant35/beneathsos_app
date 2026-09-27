import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/features/field_test/domain/presence_event.dart';
import 'package:beneathsos_app/features/field_test/presentation/mixins/device_labels_mixin.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/device_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Newest-first log of identities appearing and disappearing (address rotation study).
class PresenceLog extends ConsumerWidget with DeviceLabelsMixin {
  /// Creates the log.
  const PresenceLog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final table = ref.watch(deviceTableProvider);
    final l10n = context.l10n;
    final events = table.events.reversed.toList();
    if (events.isEmpty) return Center(child: Text(l10n.emptyEvents));
    final start = table.startedMillis ?? 0;
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (_, i) {
        final e = events[i];
        final appeared = e.change == PresenceChange.appeared;
        return ListTile(
          dense: true,
          leading: Icon(appeared ? Icons.login : Icons.logout),
          title: Text(
            '${appeared ? l10n.eventAppeared : l10n.eventGone} · ${shortKey(e.key)}',
          ),
          subtitle: Text(rssiLabel(l10n, e.rssi)),
          trailing: Text(
            clockLabel(Duration(milliseconds: e.atMillis - start)),
          ),
        );
      },
    );
  }
}
