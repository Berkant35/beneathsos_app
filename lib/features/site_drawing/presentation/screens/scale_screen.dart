import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/mixins/scale_screen_mixin.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/providers/drawing_providers.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/widgets/scale_form.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Optional after drawing: one real measurement corrects every drawn length (`ScaleSet`).
class ScaleScreen extends ConsumerStatefulWidget {
  /// Creates the screen for [sessionId].
  const ScaleScreen({required this.sessionId, super.key});

  /// The search.
  final String sessionId;

  @override
  ConsumerState<ScaleScreen> createState() => _ScaleScreenState();
}

class _ScaleScreenState extends ConsumerState<ScaleScreen>
    with ScaleScreenMixin {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final search = ref.watch(drawingSearchProvider(widget.sessionId));
    final outline = search.value?.outline;
    void skip() => SiteRoute(sessionId: widget.sessionId).go(context);
    return BeneathScaffold(
      title: l10n.scaleTitle,
      body: SingleChildScrollView(
        child: outline == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (search.hasError || search.hasValue)
                    StatusBanner(
                      kind: StatusKind.attention,
                      message: search.hasError
                          ? l10n.drawLoadFailed
                          : l10n.scaleNoOutline,
                    ),
                  const SizedBox(height: BeneathSpacing.l),
                  SecondaryButton(label: l10n.scaleSkip, onPressed: skip),
                ],
              )
            : ScaleForm(
                outline: outline,
                scale: search.value!.scale,
                side: sideOf(outline),
                onSide: (side) => setState(() => chosenSide = side),
                lengthController: lengthController,
                errorText: errorText(l10n),
                source: source,
                sourceLabel: (s) => sourceLabel(l10n, s),
                onSource: (s) => setState(() => source = s),
                onSave: () => save(outline),
                onSkip: skip,
              ),
      ),
    );
  }
}
