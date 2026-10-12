import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/features/preview/presentation/widgets/preview_banner.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// Victim mode preview (phase 10): the simplest screen — large text, one action. Until the real
/// mode exists it keeps telling a trapped person to call 112.
class VictimScreen extends StatelessWidget {
  /// Creates the screen.
  const VictimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return BeneathScaffold(
      title: l10n.victimTitle,
      // Scrolls so large system text is never cut off (no overflow error would reveal it).
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PreviewBanner(),
            const SizedBox(height: BeneathSpacing.l),
            Icon(Icons.wifi_tethering_rounded, size: 72, color: scheme.primary),
            const SizedBox(height: BeneathSpacing.m),
            Text(l10n.victimSending, style: text.displaySmall),
            const SizedBox(height: BeneathSpacing.m),
            Text(l10n.victimCalm, style: text.headlineSmall),
            const SizedBox(height: BeneathSpacing.s),
            Text(l10n.victimTap, style: text.bodyLarge),
            const SizedBox(height: BeneathSpacing.l),
            BeneathCard(
              title: l10n.preparingCardTitle,
              icon: Icons.construction_rounded,
              child: Text(l10n.victimPreparing, style: text.headlineSmall),
            ),
            const SizedBox(height: BeneathSpacing.m),
            BeneathCard(
              title: l10n.victimBattery,
              icon: Icons.battery_5_bar_rounded,
              child: Text('64 %', style: BeneathTokens.of(context).numeric),
            ),
            const SizedBox(height: BeneathSpacing.xl),
            PrimaryButton(
              label: l10n.victimSos,
              icon: Icons.volume_up_rounded,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
