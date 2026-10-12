import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/sites/presentation/providers/searches.dart';
import 'package:beneathsos_app/features/sites/presentation/widgets/search_tile.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The rescuer's searches: New search, then every real search (open ones first), and practice.
class SitesScreen extends ConsumerWidget {
  /// Creates the screen.
  const SitesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final searches = ref.watch(searchesProvider);
    return BeneathScaffold(
      title: l10n.sitesTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrimaryButton(
              label: l10n.sitesNew,
              icon: Icons.add_rounded,
              onPressed: () => const NewSiteRoute().go(context),
            ),
            const SizedBox(height: BeneathSpacing.l),
            ...switch (searches) {
              AsyncData(:final value) when value.isEmpty => [
                Text(l10n.sitesEmpty, textAlign: TextAlign.center),
              ],
              AsyncData(:final value) => [
                for (final search in value) ...[
                  SearchTile(search: search),
                  const SizedBox(height: BeneathSpacing.sm),
                ],
              ],
              AsyncError() => [
                StatusBanner(
                  kind: StatusKind.attention,
                  message: l10n.sitesLoadFailed,
                ),
              ],
              _ => const <Widget>[],
            },
            const SizedBox(height: BeneathSpacing.xl),
            SecondaryButton(
              label: l10n.sitesPractice,
              icon: Icons.school_rounded,
              onPressed: () => const PreviewNoticeRoute().go(context),
            ),
          ],
        ),
      ),
    );
  }
}
