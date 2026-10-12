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
  String get logoLabel => 'BeneathSOS';

  @override
  String get homeHeadline => 'Enkaz altındaki bir telefonu arayın';

  @override
  String get homeBody =>
      'Telefonun Bluetooth sinyalini birkaç noktadan ölçün; uygulama en olası bölgeyi gösterir.';

  @override
  String get homeStartSearch => 'Aramayı başlat';

  @override
  String get homeTrapped => 'Enkaz altındayım';

  @override
  String get homeIndependence =>
      'BeneathSOS bağımsız bir açık kaynak projedir; AFAD veya herhangi bir kamu kurumuyla bağlantısı yoktur.';

  @override
  String get poweredBy => 'Powered by Socrepho';

  @override
  String get newSiteTitle => 'Yeni arama';

  @override
  String get newSitePreparing =>
      'Bu adım hazırlanıyor. Burada enkaz alanının sınırlarını çizeceksiniz.';

  @override
  String get victimTitle => 'Enkaz altındayım';

  @override
  String get victimPreparing =>
      'Bu mod henüz hazır değil. Acil durumda 112\'yi arayın.';

  @override
  String get readinessChecking => 'Bluetooth kontrol ediliyor…';

  @override
  String get readinessReady => 'Bluetooth açık ve hazır.';

  @override
  String get readinessNeedsPermission =>
      'Bluetooth izni gerekli. İzin vermek için dokunun.';

  @override
  String get readinessPermissionInSettings =>
      'Bluetooth izni kapalı. Ayarlarda açmak için dokunun.';

  @override
  String get readinessBluetoothOff =>
      'Bluetooth kapalı. Telefonun ayarlarından açın.';

  @override
  String get readinessUnsupported =>
      'Bu telefon Bluetooth LE desteklemiyor. Başka bir telefonla arayın.';

  @override
  String get preparingCardTitle => 'Hazırlanıyor';

  @override
  String get readinessFailed =>
      'Bluetooth durumu okunamadı. Tekrar denemek için dokunun.';
}
