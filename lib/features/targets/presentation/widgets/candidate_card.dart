import 'dart:async';

import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/features/targets/domain/candidates.dart';
import 'package:beneathsos_app/features/targets/presentation/mixins/targets_mixin.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// One device that may be the trapped phone: what it is, why it is ranked here, its signal, and
/// Track / Exclude.
class CandidateCard extends StatelessWidget with TargetsMixin {
  /// Creates the card.
  const CandidateCard({
    required this.candidate,
    required this.surfaceScanned,
    required this.onTrack,
    required this.onExclude,
    super.key,
  });

  /// The device.
  final TargetCandidate candidate;

  /// Whether a surface scan was done (adds "not seen on the surface").
  final bool surfaceScanned;

  /// Track this phone (receives the label shown).
  final Future<void> Function(String label) onTrack;

  /// Exclude it as a surface phone.
  final Future<void> Function() onExclude;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = kindLabel(l10n, candidate.device.kind);
    return BeneathCard(
      title: label,
      icon: switch (candidate.strength) {
        SignalStrength.weak => Icons.signal_cellular_alt_1_bar_rounded,
        SignalStrength.medium => Icons.signal_cellular_alt_2_bar_rounded,
        SignalStrength.veryStrong => Icons.signal_cellular_alt_rounded,
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(reason(l10n, candidate, surfaceScanned: surfaceScanned)),
          Text(
            signal(l10n, candidate),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: BeneathSpacing.sm),
          SecondaryButton(
            label: l10n.targetTrack,
            icon: Icons.track_changes_rounded,
            onPressed: () => unawaited(onTrack(label)),
          ),
          const SizedBox(height: BeneathSpacing.s),
          SecondaryButton(
            label: l10n.targetExclude,
            icon: Icons.block_rounded,
            onPressed: () => unawaited(onExclude()),
          ),
        ],
      ),
    );
  }
}
