import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:beneathsos_app/features/sites/presentation/mixins/search_tile_mixin.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// One search in the list; opens its overview.
class SearchTile extends StatelessWidget with SearchTileMixin {
  /// Creates the tile.
  const SearchTile({required this.search, super.key});

  /// The search.
  final SessionSummary search;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final finished = search.closedAt != null;
    return BeneathCard(
      title: search.title,
      icon: finished ? Icons.flag_rounded : Icons.search_rounded,
      onTap: () => SiteRoute(sessionId: search.id.value).go(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(tileBody(l10n, search)),
          if (finished)
            Text(
              l10n.searchFinished,
              style: Theme.of(context).textTheme.labelLarge,
            ),
        ],
      ),
    );
  }
}
