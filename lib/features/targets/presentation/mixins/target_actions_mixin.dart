import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/targets/presentation/providers/target_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubble_core/rubble_core.dart';

/// Track and Exclude; a write that fails is said, never silent.
mixin TargetActionsMixin {
  /// Follows [peripheralKey] as a target and returns to the overview.
  Future<void> track(
    BuildContext context,
    WidgetRef ref,
    String sessionId,
    String peripheralKey,
    String label,
  ) => _write(context, () async {
    await ref
        .read(selectTargetProvider)
        .call(SessionId(sessionId), peripheralKey, label);
    if (context.mounted) SiteRoute(sessionId: sessionId).go(context);
  });

  /// Sets [peripheralKey] aside as a surface phone.
  Future<void> exclude(
    BuildContext context,
    WidgetRef ref,
    String sessionId,
    String peripheralKey,
  ) => _write(
    context,
    () => ref
        .read(excludeDeviceProvider)
        .call(SessionId(sessionId), peripheralKey),
  );

  Future<void> _write(
    BuildContext context,
    Future<void> Function() write,
  ) async {
    try {
      await write();
    } on Exception catch (error, stack) {
      AppLogger.error('targets', 'Could not store the choice', error, stack);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.targetNotSaved)));
      }
    }
  }
}
