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

  @override
  String get readinessChecking => 'Checking Bluetooth…';

  @override
  String get readinessReady => 'Bluetooth is on and ready.';

  @override
  String get readinessNeedsPermission =>
      'Bluetooth permission is needed. Tap to allow it.';

  @override
  String get readinessPermissionInSettings =>
      'Bluetooth permission is off. Tap to turn it on in Settings.';

  @override
  String get readinessBluetoothOff =>
      'Bluetooth is off. Turn it on in your phone\'s settings.';

  @override
  String get readinessUnsupported =>
      'This phone does not support Bluetooth LE. Search with another phone.';

  @override
  String get preparingCardTitle => 'Being prepared';
}
