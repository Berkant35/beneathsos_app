import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_controller.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_state.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/targets/presentation/mixins/target_actions_mixin.dart';
import 'package:beneathsos_app/features/targets/presentation/mixins/targets_mixin.dart';
import 'package:beneathsos_app/features/targets/presentation/providers/target_providers.dart';
import 'package:beneathsos_app/features/targets/presentation/providers/tracked_devices.dart';
import 'package:beneathsos_app/features/targets/presentation/widgets/candidate_card.dart';
import 'package:beneathsos_app/features/targets/presentation/widgets/scan_blocked_banner.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Choose the phone to search for: devices heard now, most promising first, each with the reason.
class TargetsScreen extends ConsumerWidget
    with TargetActionsMixin, TargetsMixin {
  /// Creates the screen for [sessionId].
  const TargetsScreen({required this.sessionId, super.key});

  /// The search.
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    ref.watch(scanWhileOpenProvider);
    final scan = ref.watch(scanControllerProvider);
    final search = ref.watch(sessionStateProvider(sessionId)).value;
    final candidates = candidatesFor(ref.watch(trackedDevicesProvider), search);
    final surfaceScanned = search?.blacklist.isNotEmpty ?? false;
    return BeneathScaffold(
      title: l10n.targetTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StatusBanner(
              kind: StatusKind.ready,
              message: l10n.targetsHintExclude,
              icon: Icons.phonelink_ring_rounded,
            ),
            if (!surfaceScanned) ...[
              const SizedBox(height: BeneathSpacing.sm),
              StatusBanner(
                kind: StatusKind.attention,
                message: l10n.targetsNoSurfaceScan,
                onTap: () => AmbientRoute(sessionId: sessionId).go(context),
              ),
            ],
            if (scan is! ScanRunning && scan is! ScanIdle) ...[
              const SizedBox(height: BeneathSpacing.sm),
              ScanBlockedBanner(scan: scan),
            ],
            const SizedBox(height: BeneathSpacing.m),
            if (candidates.isEmpty)
              Text(l10n.targetsNone, textAlign: TextAlign.center),
            for (final candidate in candidates) ...[
              CandidateCard(
                key: ValueKey(candidate.device.key),
                candidate: candidate,
                surfaceScanned: surfaceScanned,
                onTrack: (label) =>
                    track(context, ref, sessionId, candidate.device.key, label),
                onExclude: () =>
                    exclude(context, ref, sessionId, candidate.device.key),
              ),
              const SizedBox(height: BeneathSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}
