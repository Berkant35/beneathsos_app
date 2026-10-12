import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/features/victim/domain/victim_state.dart';
import 'package:beneathsos_app/features/victim/presentation/mixins/victim_mixin.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// Whether the phone is calling out, and what to do when it is not.
class VictimStatus extends StatelessWidget with VictimMixin {
  /// Creates the status for [state]; [onAction] fixes what can be fixed.
  const VictimStatus({required this.state, required this.onAction, super.key});

  /// Victim mode's state.
  final VictimState state;

  /// Allow, Open Settings or Try again.
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final calling = state is VictimCallingOut;
    final action = actionLabel(l10n, state);
    return Semantics(
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            calling
                ? Icons.wifi_tethering_rounded
                : Icons.wifi_tethering_error_rounded,
            size: 72,
            color: calling ? scheme.primary : scheme.error,
          ),
          const SizedBox(height: BeneathSpacing.m),
          Text(headline(l10n, state), style: text.headlineMedium),
          if (state case final VictimCallingOut calling) ...[
            const SizedBox(height: BeneathSpacing.m),
            for (final line in details(l10n, calling))
              Text(line, style: text.titleMedium),
            const SizedBox(height: BeneathSpacing.m),
            Text(l10n.victimCalm, style: text.bodyLarge),
            const SizedBox(height: BeneathSpacing.s),
            Text(l10n.victimTap, style: text.bodyLarge),
          ],
          if (action != null) ...[
            const SizedBox(height: BeneathSpacing.m),
            SecondaryButton(label: action, onPressed: onAction),
          ],
        ],
      ),
    );
  }
}
