import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/targets/domain/choice_result.dart';
import 'package:beneathsos_app/features/targets/presentation/providers/target_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Track, Exclude (with Undo) and Put back; a choice that cannot be stored is said, never silent.
mixin TargetActionsMixin {
  /// Follows [key] as a target and returns to the overview.
  Future<void> track(
    BuildContext context,
    WidgetRef ref,
    String sessionId,
    String key,
    String label,
  ) async {
    final result = await ref
        .read(targetChoiceProvider(sessionId).notifier)
        .track(key, label);
    if (!context.mounted) return;
    if (result == ChoiceResult.done) {
      SiteRoute(sessionId: sessionId).go(context);
    } else {
      _tell(context, result);
    }
  }

  /// Sets [key] aside; the snackbar offers Undo, so a wrong tap is never permanent.
  Future<void> exclude(
    BuildContext context,
    WidgetRef ref,
    String sessionId,
    String key,
    String label,
  ) async {
    final choice = ref.read(targetChoiceProvider(sessionId).notifier);
    final result = await choice.exclude(key);
    if (!context.mounted) return;
    if (result != ChoiceResult.done) return _tell(context, result);
    final l10n = context.l10n;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.excludeDone(label)),
          duration: const Duration(seconds: 8),
          action: SnackBarAction(
            label: l10n.drawUndo,
            onPressed: () => choice.putBack(key),
          ),
        ),
      );
  }

  /// Puts [key] back among the candidates.
  Future<void> putBack(
    BuildContext context,
    WidgetRef ref,
    String sessionId,
    String key,
  ) async {
    final result = await ref
        .read(targetChoiceProvider(sessionId).notifier)
        .putBack(key);
    if (context.mounted) _tell(context, result);
  }

  void _tell(BuildContext context, ChoiceResult result) {
    if (result != ChoiceResult.failed) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.targetNotSaved)));
  }
}
