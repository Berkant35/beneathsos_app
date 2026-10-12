import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/preview/presentation/widgets/preview_banner.dart';
import 'package:beneathsos_app/features/preview/presentation/widgets/probability_painter.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// Preview 6 — probability map: an area with its confidence, never a single pin (rule 1).
class PreviewMapScreen extends StatelessWidget {
  /// Creates the screen.
  const PreviewMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final legend = [
      (Icons.circle, l10n.mapHeard),
      (Icons.circle_outlined, l10n.mapNoSignal),
      (Icons.add_circle_outline_rounded, l10n.mapNext),
    ];
    return BeneathScaffold(
      title: l10n.mapTitle,
      // Scrolls so large text never squeezes the map away; the map keeps a square.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PreviewBanner(),
            const SizedBox(height: BeneathSpacing.s),
            StatusBanner(kind: StatusKind.attention, message: l10n.mapRotation),
            const SizedBox(height: BeneathSpacing.s),
            AspectRatio(
              aspectRatio: 1,
              // A canvas, not a card: a framed square surface.
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainer,
                  border: Border.all(color: scheme.outlineVariant),
                  borderRadius: BorderRadius.circular(BeneathSizes.radius),
                ),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: ProbabilityPainter(
                    outline: scheme.primary,
                    grid: scheme.outlineVariant,
                    label: text.bodyMedium!.copyWith(color: scheme.onSurface),
                    background: scheme.surfaceContainer,
                    mostLikely: l10n.mapMostLikely,
                    region90: l10n.mapRegion90,
                    noSignal: l10n.mapNoSignal,
                  ),
                ),
              ),
            ),
            const SizedBox(height: BeneathSpacing.s),
            Wrap(
              spacing: BeneathSpacing.m,
              runSpacing: BeneathSpacing.xs,
              children: [
                for (final (icon, label) in legend)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 16, color: scheme.primary),
                      const SizedBox(width: BeneathSpacing.xs),
                      Flexible(child: Text(label, style: text.bodyMedium)),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: BeneathSpacing.sm),
            PrimaryButton(
              label: l10n.mapMeasure,
              icon: Icons.add_location_alt_rounded,
              onPressed: () => const PreviewMeasureRoute().go(context),
            ),
          ],
        ),
      ),
    );
  }
}
