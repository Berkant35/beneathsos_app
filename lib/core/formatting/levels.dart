import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:rubble_core/rubble_core.dart';

/// "Ground floor (bottom)", "Don't know", …
String levelLabel(AppLocalizations l10n, TrappedLevel level) => switch (level) {
  TrappedLevel.upper => l10n.levelUpper,
  TrappedLevel.middle => l10n.levelMiddle,
  TrappedLevel.bottom => l10n.levelBottom,
  TrappedLevel.basement => l10n.levelBasement,
  TrappedLevel.unknown => l10n.levelUnknown,
};
