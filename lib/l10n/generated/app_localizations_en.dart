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

  @override
  String get logoLabel => 'BeneathSOS';

  @override
  String get homeHeadline => 'Search for a phone under rubble';

  @override
  String get homeBody =>
      'Measure the phone\'s Bluetooth signal at a few points; the app shows the most likely area.';

  @override
  String get homeStartSearch => 'Start a search';

  @override
  String get homeTrapped => 'I am trapped';

  @override
  String get homeIndependence =>
      'BeneathSOS is an independent open-source project and is not affiliated with AFAD or any government agency.';

  @override
  String get poweredBy => 'Powered by Socrepho';

  @override
  String get newSiteTitle => 'New search';

  @override
  String get newSitePreparing =>
      'This step is being prepared. Here you will draw the outline of the rubble site.';

  @override
  String get victimTitle => 'I am trapped';

  @override
  String get victimPreparing =>
      'This mode is not ready yet. In an emergency, call 112.';
}
