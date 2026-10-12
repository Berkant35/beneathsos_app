import 'dart:async';

import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/features/victim/domain/victim_state.dart';
import 'package:beneathsos_app/features/victim/presentation/providers/victim_providers.dart';
import 'package:beneathsos_app/features/victim/presentation/widgets/stop_calling_dialog.dart';
import 'package:beneathsos_app/features/victim/presentation/widgets/victim_status.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Victim mode (roadmap 10): the phone calls out to rescuers (a Bluetooth beacon) as long as this
/// screen is open — large text, one main action, the SOS sound and 112. Any touch tells rescuers that
/// someone touched the phone. Back asks before the signal stops.
class VictimScreen extends ConsumerWidget {
  /// Creates the screen.
  const VictimScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final state = ref.watch(victimControllerProvider);
    final sos = ref.watch(sosSoundControllerProvider);
    final controller = ref.read(victimControllerProvider.notifier);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || !await StopCallingDialog.confirm(context)) return;
        if (context.mounted) Navigator.of(context).pop();
      },
      child: BeneathScaffold(
        title: l10n.victimTitle,
        // Every touch is a sign of life; Listener sees taps on buttons too.
        body: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (_) => controller.touched(),
          // Scrolls so large system text is never cut off.
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: BeneathSpacing.l),
                VictimStatus(
                  state: state,
                  onAction: () => unawaited(
                    state is VictimNeedsPermission && state.permanently
                        ? controller.openSettings()
                        : controller.retry(),
                  ),
                ),
                const SizedBox(height: BeneathSpacing.xl),
                PrimaryButton(
                  label: sos ? l10n.victimSosStop : l10n.victimSos,
                  icon: sos
                      ? Icons.volume_off_rounded
                      : Icons.volume_up_rounded,
                  onPressed: () => unawaited(
                    ref.read(sosSoundControllerProvider.notifier).toggle(),
                  ),
                ),
                const SizedBox(height: BeneathSpacing.l),
                BeneathCard(
                  icon: Icons.call_rounded,
                  child: Text(l10n.victim112, style: text.headlineSmall),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
