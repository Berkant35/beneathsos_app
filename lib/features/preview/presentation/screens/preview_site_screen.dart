import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/preview/presentation/widgets/outline_painter.dart';
import 'package:beneathsos_app/features/preview/presentation/widgets/preview_banner.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Preview 2 — rubble site outline: corners tapped while walking around the rubble.
class PreviewSiteScreen extends StatelessWidget {
  /// Creates the screen.
  const PreviewSiteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final metres = NumberFormat('0.0', l10n.localeName);
    return BeneathScaffold(
      title: l10n.siteTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PreviewBanner(),
            const SizedBox(height: BeneathSpacing.sm),
            StatusBanner(
              kind: StatusKind.ready,
              message: l10n.siteHint,
              icon: Icons.touch_app_rounded,
            ),
            const SizedBox(height: BeneathSpacing.m),
            BeneathCard(
              child: AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  painter: OutlinePainter(
                    grid: scheme.outlineVariant,
                    outline: scheme.primary,
                    label: Theme.of(context).textTheme.bodyMedium!
                        .copyWith(color: scheme.onSurface),
                    lengths: [
                      for (final m in const [18.2, 12.4, 17.5, 13.1])
                        '${metres.format(m)} m',
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: BeneathSpacing.s),
            Text(
              l10n.siteSummary(metres.format(18.2), metres.format(12.4)),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: BeneathSpacing.l),
            PrimaryButton(
              label: l10n.siteDone,
              icon: Icons.check_rounded,
              onPressed: () => const PreviewScanRoute().go(context),
            ),
          ],
        ),
      ),
    );
  }
}
