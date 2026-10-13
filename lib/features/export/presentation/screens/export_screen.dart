import 'dart:async';

import 'package:beneathsos_app/core/disclaimer/disclaimer_content.dart';
import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/features/export/presentation/mixins/export_mixin.dart';
import 'package:beneathsos_app/features/export/presentation/providers/export_providers.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Export a search (roadmap 11): the disclaimer first (rule 5), what the files hold, then the system
/// share sheet — the app itself sends nothing (rule 4).
class ExportScreen extends ConsumerWidget with ExportMixin {
  /// Creates the screen for [sessionId].
  const ExportScreen({required this.sessionId, super.key});

  /// The search.
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final state = ref.watch(exportControllerProvider(sessionId));
    final result = outcome(l10n, state);
    return BeneathScaffold(
      title: l10n.exportTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DisclaimerContent(),
            const SizedBox(height: BeneathSpacing.l),
            Text(l10n.exportContents, style: text.bodyLarge),
            if (result != null) ...[
              const SizedBox(height: BeneathSpacing.m),
              StatusBanner(
                kind: state is ExportFailed
                    ? StatusKind.attention
                    : StatusKind.ready,
                message: result,
              ),
            ],
            const SizedBox(height: BeneathSpacing.l),
            PrimaryButton(
              label: l10n.exportShare,
              icon: Icons.ios_share_rounded,
              onPressed: state is Exporting
                  ? null
                  : () => unawaited(
                      ref
                          .read(exportControllerProvider(sessionId).notifier)
                          .export(
                            disclaimer: fileDisclaimer(),
                            subject: l10n.exportTitle,
                          ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
