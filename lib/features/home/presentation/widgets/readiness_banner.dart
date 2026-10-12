import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/readiness/presentation/providers/readiness_controller.dart';
import 'package:beneathsos_app/features/home/presentation/mixins/readiness_banner_mixin.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether this phone can search right now, above the home actions.
class ReadinessBanner extends ConsumerWidget with ReadinessBannerMixin {
  /// Creates the banner.
  const ReadinessBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = bannerFor(
      context.l10n,
      ref.watch(readinessControllerProvider),
      ref.read(readinessControllerProvider.notifier),
    );
    return StatusBanner(
      kind: content.kind,
      message: content.message,
      icon: content.icon,
      onTap: content.onTap,
    );
  }
}
