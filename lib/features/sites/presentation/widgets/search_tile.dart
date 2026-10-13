import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:beneathsos_app/features/sites/presentation/mixins/search_tile_mixin.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// One search in the list; opens its overview, or deletes it.
class SearchTile extends StatelessWidget with SearchTileMixin {
  /// Creates the tile.
  const SearchTile({required this.search, required this.onDelete, super.key});

  /// The search.
  final SessionSummary search;

  /// Asks, then deletes it.
  final VoidCallback onDelete;

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
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded),
              label: Text(l10n.searchDelete),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
