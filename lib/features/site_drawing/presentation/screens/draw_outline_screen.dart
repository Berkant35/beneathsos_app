import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/providers/drawing_providers.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/widgets/draw_outline_body.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/widgets/leave_drawing_dialog.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Draw the rubble outline of a search (roadmap 5). The canvas runs edge to edge (`padded: false`).
class DrawOutlineScreen extends ConsumerWidget {
  /// Creates the screen for [sessionId].
  const DrawOutlineScreen({required this.sessionId, super.key});

  /// The search.
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final draft = ref.watch(outlineDraftControllerProvider(sessionId));
    final scale = ref.watch(sessionStateProvider(sessionId)).value?.scale ?? 1;
    final unsaved = ref
        .read(outlineDraftControllerProvider(sessionId).notifier)
        .hasUnsavedChanges;
    // Back (app bar, Android, iOS swipe) never throws away corners silently.
    return PopScope(
      canPop: !unsaved,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || !await LeaveDrawingDialog.confirm(context)) return;
        if (context.mounted) Navigator.of(context).pop();
      },
      child: BeneathScaffold(
        title: l10n.drawTitle,
        padded: false,
        body: switch (draft) {
          _ when draft.hasError => Padding(
            padding: BeneathSpacing.pageFor(MediaQuery.sizeOf(context).width),
            child: StatusBanner(
              kind: StatusKind.attention,
              message: l10n.drawLoadFailed,
            ),
          ),
          AsyncData(:final value) => DrawOutlineBody(
            sessionId: sessionId,
            draft: value,
            scale: scale,
          ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
