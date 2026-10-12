import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_controller.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_state.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_while_open.dart';
import 'package:beneathsos_app/core/scanning/presentation/widgets/scan_blocked_banner.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/targets/domain/candidates.dart';
import 'package:beneathsos_app/features/targets/presentation/mixins/target_actions_mixin.dart';
import 'package:beneathsos_app/features/targets/presentation/mixins/targets_mixin.dart';
import 'package:beneathsos_app/features/targets/presentation/providers/target_providers.dart';
import 'package:beneathsos_app/features/targets/presentation/providers/tracked_devices.dart';
import 'package:beneathsos_app/features/targets/presentation/widgets/candidate_card.dart';
import 'package:beneathsos_app/features/targets/presentation/widgets/set_aside_list.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Choose the phone to search for: devices heard now, most promising first when they appear; cards
/// keep their place afterwards (Sort again re-ranks), so they never move under a finger.
class TargetsScreen extends ConsumerStatefulWidget {
  /// Creates the screen for [sessionId].
  const TargetsScreen({required this.sessionId, super.key});

  /// The search.
  final String sessionId;

  @override
  ConsumerState<TargetsScreen> createState() => _TargetsScreenState();
}

class _TargetsScreenState extends ConsumerState<TargetsScreen>
    with TargetActionsMixin, TargetsMixin {
  /// Keys in the order shown (form state only).
  var _shown = <String>[];

  /// A surface scan older than this may miss phones that changed identity.
  static const _staleScan = Duration(minutes: 10);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final id = widget.sessionId;
    ref.watch(scanWhileOpenProvider);
    final scan = ref.watch(scanControllerProvider);
    final heard = ref.watch(trackedDevicesProvider);
    final search = ref.watch(sessionStateProvider(id)).value;
    final busy = ref.watch(targetChoiceProvider(id));
    final candidates = keepOrder(_shown, candidatesFor(heard, search));
    _shown = [for (final c in candidates) c.device.key];
    final lastScan = search?.lastSurfaceScan;
    final scanAge = lastScan == null
        ? null
        : ref
              .read(clockProvider)()
              .difference(
                DateTime.fromMillisecondsSinceEpoch(lastScan.physicalMs),
              );
    void openScan() => AmbientRoute(sessionId: id).go(context);
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
            if (scanAge == null || scanAge >= _staleScan) ...[
              const SizedBox(height: BeneathSpacing.sm),
              StatusBanner(
                kind: StatusKind.attention,
                message: scanAge == null
                    ? l10n.targetsNoSurfaceScan
                    : l10n.targetsSurfaceScanOld(scanAge.inMinutes),
                onTap: openScan,
              ),
            ],
            if (scan is! ScanRunning && scan is! ScanIdle) ...[
              const SizedBox(height: BeneathSpacing.sm),
              ScanBlockedBanner(scan: scan),
            ],
            const SizedBox(height: BeneathSpacing.m),
            if (candidates.isEmpty)
              Text(l10n.targetsNone, textAlign: TextAlign.center)
            else
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton.icon(
                  onPressed: () => setState(() => _shown = []),
                  icon: const Icon(Icons.sort_rounded),
                  label: Text(l10n.sortAgain),
                ),
              ),
            for (final candidate in candidates) ...[
              CandidateCard(
                key: ValueKey(candidate.device.key),
                candidate: candidate,
                surfaceScanned: lastScan != null,
                enabled: !busy,
                onTrack: (label) =>
                    track(context, ref, id, candidate.device.key, label),
                onExclude: (label) =>
                    exclude(context, ref, id, candidate.device.key, label),
              ),
              const SizedBox(height: BeneathSpacing.sm),
            ],
            if (search != null && search.blacklist.isNotEmpty)
              SetAsideList(
                keys: search.blacklist.toList(),
                heard: heard,
                enabled: !busy,
                onPutBack: (key) => putBack(context, ref, id, key),
              ),
          ],
        ),
      ),
    );
  }
}
