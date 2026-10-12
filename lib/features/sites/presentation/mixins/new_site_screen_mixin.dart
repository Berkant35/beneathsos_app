import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/sites/domain/site_name.dart';
import 'package:beneathsos_app/features/sites/presentation/providers/new_search.dart';
import 'package:beneathsos_app/features/sites/presentation/screens/new_site_screen.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The name field and Create of the new-search form.
mixin NewSiteScreenMixin on ConsumerState<NewSiteScreen> {
  /// The site name being typed.
  final nameController = TextEditingController();

  /// What is wrong with the name after the last Create (form state only).
  SiteNameProblem? problem;

  /// The error under the field, if any.
  String? errorText(AppLocalizations l10n) => switch (problem) {
    null => null,
    EmptySiteName() => l10n.newSiteEmpty,
    SiteNameTooLong() => l10n.newSiteTooLong,
  };

  /// Checks the name, creates the search and opens its overview (replacing this form).
  Future<void> submit() async {
    final checked = checkSiteName(nameController.text);
    setState(() => problem = checked.problem);
    final name = checked.name;
    if (name == null) return;
    final id = await ref.read(newSearchProvider.notifier).create(name);
    if (id != null && mounted) SiteRoute(sessionId: id.value).go(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
