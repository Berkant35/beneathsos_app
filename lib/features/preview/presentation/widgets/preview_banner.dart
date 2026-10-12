import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// Marks a mockup screen: sample data, nothing is measured (roadmap 1.4 preview).
class PreviewBanner extends StatelessWidget {
  /// Creates the banner.
  const PreviewBanner({super.key});

  @override
  Widget build(BuildContext context) => StatusBanner(
    kind: StatusKind.ready,
    message: context.l10n.previewBanner,
    icon: Icons.visibility_rounded,
  );
}
