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
  String get fieldTestTitle => 'Saha testi';

  @override
  String get scanStart => 'Taramayı başlat';

  @override
  String get scanStop => 'Taramayı durdur';

  @override
  String get scanStateIdle => 'Tarayıcı durdu';

  @override
  String scanStateRunning(int devices, int rate) {
    return 'Taranıyor — $devices cihaz, saniyede $rate örnek';
  }

  @override
  String get scanStateNeedsPermission =>
      'Tarama için Bluetooth / konum izni gerekiyor.';

  @override
  String get scanStateBluetoothOff => 'Bluetooth kapalı. Taramak için açın.';

  @override
  String scanStateFailed(String reason) {
    return 'Tarama başarısız: $reason';
  }

  @override
  String get actionGrantPermission => 'İzin ver';

  @override
  String get actionOpenSettings => 'Ayarları aç';

  @override
  String filterMinRssi(int value) {
    return 'En düşük RSSI: $value dBm';
  }

  @override
  String get filterAppleOnly => 'Yalnız Apple';

  @override
  String get filterTargetsOnly => 'Yalnız hedefler';

  @override
  String get tabDevices => 'Cihazlar';

  @override
  String get tabEvents => 'Kimlik günlüğü';

  @override
  String get emptyDevices => 'Henüz cihaz yok. Tarayıcıyı açık tutun.';

  @override
  String get emptyEvents => 'Henüz beliren ya da kaybolan cihaz yok.';

  @override
  String get kindAppleFindMy => 'Apple · Find My';

  @override
  String get kindAppleNearby => 'Apple · Nearby';

  @override
  String get kindAppleOther => 'Apple';

  @override
  String get kindSamsung => 'Samsung';

  @override
  String get kindMicrosoft => 'Microsoft';

  @override
  String get kindGoogle => 'Google';

  @override
  String get kindOther => 'Diğer';

  @override
  String get kindUnknown => 'Üretici verisi yok';

  @override
  String lastSeenSeconds(int seconds) {
    return '$seconds sn önce';
  }

  @override
  String rssiValue(int value) {
    return '$value dBm';
  }

  @override
  String get noValue => '—';

  @override
  String get statNow => 'Şu an';

  @override
  String get statMedian5 => 'Medyan 5 sn';

  @override
  String get statMedian15 => 'Medyan 15 sn';

  @override
  String get statStdDev15 => 'Std sapma 15 sn';

  @override
  String get statRate => 'Örnek/sn';

  @override
  String get statCount => 'Toplam örnek';

  @override
  String detailFirstSeen(String elapsed) {
    return 'Aynı kimlikle $elapsed';
  }

  @override
  String get detailRotationHint =>
      'Telefonlar Bluetooth kimliğini yaklaşık 15 dakikada bir değiştirir. Ölçümleri bundan önce bitirin.';

  @override
  String detailGone(int seconds) {
    return '$seconds sn\'dir görülmüyor — kimlik değişmiş olabilir.';
  }

  @override
  String get detailPayload => 'Son üretici verisi';

  @override
  String get detailCompany => 'Şirket kimliği';

  @override
  String get detailName => 'Yayınlanan ad';

  @override
  String get targetSet => 'Hedef olarak işaretle';

  @override
  String get targetUnset => 'Hedeften çıkar';

  @override
  String get relinkTitle => 'Olası yeni kimlik';

  @override
  String relinkBody(int seconds, int delta) {
    return 'Hedef kaybolduktan $seconds sn sonra belirdi, RSSI farkı $delta dB.';
  }

  @override
  String get relinkAccept => 'Hedef yap';

  @override
  String get eventAppeared => 'Belirdi';

  @override
  String get eventGone => 'Kayboldu';

  @override
  String get recordStart => 'CSV kaydet';

  @override
  String get recordStop => 'Kaydı durdur';

  @override
  String recordRunning(int count, String elapsed) {
    return 'Kaydediliyor · $count örnek · $elapsed';
  }

  @override
  String get recordShare => 'Son kaydı paylaş';

  @override
  String get markerAdd => 'İşaretleyici ekle';

  @override
  String get markerHint => 'ör. N1 · 1 m · beton altında';

  @override
  String get markerSaved => 'İşaretleyici kaydedildi';

  @override
  String get actionCancel => 'Vazgeç';

  @override
  String get actionSave => 'Kaydet';

  @override
  String get disclaimer =>
      'Araştırma aracı. Sinyal gücü bir konumu asla kanıtlamaz.';
}
