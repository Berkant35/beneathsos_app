import 'dart:async';

import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/site_depth/presentation/mixins/depth_screen_mixin.dart';
import 'package:beneathsos_app/features/site_depth/presentation/widgets/level_choice.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The depth the signal cannot tell: how high the rubble stands and where the person most likely was
/// (`RubbleDepthSet`); the map and the signal circles use it.
class DepthScreen extends ConsumerStatefulWidget {
  /// Creates the screen for [sessionId].
  const DepthScreen({required this.sessionId, super.key});

  /// The search.
  final String sessionId;

  @override
  ConsumerState<DepthScreen> createState() => _DepthScreenState();
}

class _DepthScreenState extends ConsumerState<DepthScreen>
    with DepthScreenMixin {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    prefill(ref.watch(sessionStateProvider(widget.sessionId)).value?.depth);
    return BeneathScaffold(
      title: l10n.depthTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.depthIntro, style: text.bodyLarge),
            const SizedBox(height: BeneathSpacing.l),
            TextField(
              controller: heightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.depthHeight,
                errorText: errorText(l10n),
                errorMaxLines: 3,
              ),
            ),
            const SizedBox(height: BeneathSpacing.sm),
            Wrap(
              spacing: BeneathSpacing.sm,
              runSpacing: BeneathSpacing.sm,
              children: [
                for (final floors in const [1, 2, 3, 4])
                  ActionChip(
                    label: Text(floorsLabel(context, floors)),
                    onPressed: () => useFloors(floors),
                  ),
              ],
            ),
            const SizedBox(height: BeneathSpacing.l),
            Text(l10n.depthLevel, style: text.titleMedium),
            const SizedBox(height: BeneathSpacing.sm),
            LevelChoice(
              value: level,
              onChanged: (chosen) => setState(() => level = chosen),
            ),
            if (saveFailed) ...[
              const SizedBox(height: BeneathSpacing.m),
              StatusBanner(
                kind: StatusKind.attention,
                message: l10n.depthSaveFailed,
              ),
            ],
            const SizedBox(height: BeneathSpacing.l),
            PrimaryButton(
              label: l10n.depthSave,
              icon: Icons.check_rounded,
              onPressed: () => unawaited(save()),
            ),
          ],
        ),
      ),
    );
  }
}
