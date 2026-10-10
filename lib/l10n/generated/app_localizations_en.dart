// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BeneathSOS';

  @override
  String get homeUnderConstructionTitle => 'Under construction';

  @override
  String get homeUnderConstructionBody =>
      'The rescuer and victim flows are being designed. Follow the public roadmap for progress.';
}
