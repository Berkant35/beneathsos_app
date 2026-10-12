import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/sites/domain/create_search_result.dart';
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

  /// Whether the last Create could not store the search.
  bool failed = false;

  /// The error under the field, if any.
  String? errorText(AppLocalizations l10n) => switch (problem) {
    EmptySiteName() => l10n.newSiteEmpty,
    SiteNameTooLong() => l10n.newSiteTooLong,
    null => failed ? l10n.newSiteFailed : null,
  };

  /// Checks the name, creates the search and opens its overview (replacing this form).
  Future<void> submit() async {
    final checked = checkSiteName(nameController.text);
    setState(() {
      problem = checked.problem;
      failed = false;
    });
    final name = checked.name;
    if (name == null) return;
    final result = await ref.read(newSearchProvider.notifier).create(name);
    if (!mounted) return;
    switch (result) {
      case SearchCreated(:final id):
        SiteRoute(sessionId: id.value).go(context);
      case CreateFailed():
        setState(() => failed = true);
      case CreateAlreadyRunning():
        break;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
