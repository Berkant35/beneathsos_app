// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'BeneathSOS';

  @override
  String get homeUnderConstructionTitle => 'Yapım aşamasında';

  @override
  String get homeUnderConstructionBody =>
      'Kurtarıcı ve kurban akışları tasarlanıyor. İlerlemeyi herkese açık yol haritasından takip edebilirsiniz.';
}
