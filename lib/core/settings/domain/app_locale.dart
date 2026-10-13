import 'dart:ui';

import 'package:beneathsos_app/core/settings/domain/app_settings.dart';

/// The locale for [language]; null follows the phone.
Locale? localeOf(AppLanguage language) => switch (language) {
  AppLanguage.system => null,
  AppLanguage.turkish => const Locale('tr'),
  AppLanguage.english => const Locale('en'),
};
