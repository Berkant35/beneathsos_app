import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// `context.l10n.someKey` — the only way user-facing text reaches widgets.
extension L10nX on BuildContext {
  /// Localised strings for the current locale.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
