import 'dart:async';

import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/features/targets/domain/tracker_snapshot.dart';
import 'package:beneathsos_app/features/targets/presentation/mixins/targets_mixin.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// The phones set aside (surface scan or Exclude), each with Put back — so a wrong exclusion can
/// always be seen and undone.
class SetAsideList extends StatelessWidget with TargetsMixin {
  /// Creates the list.
  const SetAsideList({
    required this.keys,
    required this.heard,
    required this.onPutBack,
    required this.enabled,
    super.key,
  });

  /// Peripheral keys set aside.
  final List<String> keys;

  /// Devices heard now (for their type and signal).
  final TrackerSnapshot heard;

  /// Put a key back.
  final Future<void> Function(String key) onPutBack;

  /// False while another choice is being stored.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final byKey = {for (final d in heard.devices) d.key: d};
    return ExpansionTile(
      title: Text(l10n.setAsideTitle(keys.length)),
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      children: [
        for (final key in keys) ...[
          Row(
            children: [
              Expanded(
                child: Text(switch (byKey[key]) {
                  final DeviceSummary d =>
                    '${kindLabel(l10n, d.kind)} · ${l10n.targetSignal(d.lastRssi.toString().replaceFirst('-', '−'))}',
                  null => l10n.setAsideNotHeard,
                }),
              ),
              const SizedBox(width: BeneathSpacing.sm),
              TextButton(
                onPressed: enabled ? () => unawaited(onPutBack(key)) : null,
                child: Text(l10n.putBack),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
