import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/features/field_test/domain/relink.dart';
import 'package:beneathsos_app/features/field_test/presentation/mixins/device_labels_mixin.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/device_table.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/target_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Proposes new identities for a target that stopped advertising.
class RelinkSuggestions extends ConsumerWidget with DeviceLabelsMixin {
  /// Creates the list for [targetKey].
  const RelinkSuggestions({required this.targetKey, super.key});

  /// The vanished target.
  final String targetKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(deviceTableProvider).events;
    final candidates = suggestRelinks(targetKey: targetKey, events: events);
    if (candidates.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(title: Text(l10n.relinkTitle)),
          for (final c in candidates)
            ListTile(
              title: Text(shortKey(c.key)),
              subtitle: Text(l10n.relinkBody(c.gapSeconds, c.rssiDelta)),
              trailing: TextButton(
                onPressed: () => ref
                    .read(targetSelectionProvider.notifier)
                    .relink(targetKey, c.key),
                child: Text(l10n.relinkAccept),
              ),
            ),
        ],
      ),
    );
  }
}
