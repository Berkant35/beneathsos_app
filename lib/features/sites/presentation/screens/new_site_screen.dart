import 'dart:async';

import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/features/sites/domain/site_name.dart';
import 'package:beneathsos_app/features/sites/presentation/mixins/new_site_screen_mixin.dart';
import 'package:beneathsos_app/features/sites/presentation/providers/new_search.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A new search: the name of the site, then Create.
class NewSiteScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const NewSiteScreen({super.key});

  @override
  ConsumerState<NewSiteScreen> createState() => _NewSiteScreenState();
}

class _NewSiteScreenState extends ConsumerState<NewSiteScreen>
    with NewSiteScreenMixin {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final creating = ref.watch(newSearchProvider);
    return BeneathScaffold(
      title: l10n.newSiteTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              maxLength: maxSiteNameLength,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => unawaited(submit()),
              decoration: InputDecoration(
                labelText: l10n.newSiteLabel,
                hintText: l10n.newSiteHint,
                errorText: errorText(l10n),
                errorMaxLines: 3,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: BeneathSpacing.l),
            PrimaryButton(
              label: l10n.newSiteCreate,
              icon: Icons.check_rounded,
              // Errors are handled inside; a second tap while creating does nothing.
              onPressed: creating ? null : () => unawaited(submit()),
            ),
          ],
        ),
      ),
    );
  }
}
