import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/targets/domain/ambient_state.dart';
import 'package:beneathsos_app/features/targets/domain/candidates.dart';
import 'package:beneathsos_app/features/targets/presentation/providers/target_providers.dart';
import 'package:beneathsos_app/features/targets/presentation/widgets/scan_blocked_banner.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The 30 s surface scan (roadmap 6): standing 10 m from the rubble, every phone heard strongly is set
/// aside, so team and bystander phones are never suggested as targets.
class AmbientScanScreen extends ConsumerWidget {
  /// Creates the screen for [sessionId].
  const AmbientScanScreen({required this.sessionId, super.key});

  /// The search.
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    ref.watch(scanWhileOpenProvider);
    final state = ref.watch(ambientScanControllerProvider(sessionId));
    return BeneathScaffold(
      title: l10n.ambientTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StatusBanner(
              kind: StatusKind.ready,
              message: l10n.scanStand,
              icon: Icons.directions_walk_rounded,
            ),
            const SizedBox(height: BeneathSpacing.sm),
            Text(l10n.scanBody, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: BeneathSpacing.l),
            ...switch (state) {
              AmbientScanning(:final remaining, :final heard) => [
                Center(
                  child: CountdownRing(
                    total: AmbientPolicy.duration,
                    remaining: remaining,
                    semanticLabel: l10n.secondsLeft(remaining.inSeconds),
                    size: 180,
                  ),
                ),
                const SizedBox(height: BeneathSpacing.m),
                Text(l10n.ambientHeard(heard), textAlign: TextAlign.center),
              ],
              AmbientBlocked(:final scan) => [ScanBlockedBanner(scan: scan)],
              AmbientSaving() => const <Widget>[],
              AmbientDone(:final setAside) => [
                StatusBanner(
                  kind: StatusKind.ready,
                  message: l10n.ambientDone(setAside),
                  icon: Icons.check_circle_rounded,
                ),
                const SizedBox(height: BeneathSpacing.l),
                PrimaryButton(
                  label: l10n.ambientChoose,
                  icon: Icons.phonelink_ring_rounded,
                  onPressed: () =>
                      TargetsRoute(sessionId: sessionId).go(context),
                ),
                const SizedBox(height: BeneathSpacing.sm),
                SecondaryButton(
                  label: l10n.ambientBack,
                  onPressed: () => SiteRoute(sessionId: sessionId).go(context),
                ),
              ],
              AmbientNotSaved() => [
                StatusBanner(
                  kind: StatusKind.attention,
                  message: l10n.ambientNotSaved,
                ),
                const SizedBox(height: BeneathSpacing.l),
                PrimaryButton(
                  label: l10n.ambientAgain,
                  onPressed: () =>
                      ref.invalidate(ambientScanControllerProvider(sessionId)),
                ),
              ],
            },
          ],
        ),
      ),
    );
  }
}
