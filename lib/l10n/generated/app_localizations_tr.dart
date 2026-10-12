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

  @override
  String get previewBanner => 'Önizleme — örnek veri, gerçek ölçüm yok.';

  @override
  String get noticeTitle => 'Başlamadan önce';

  @override
  String get noticeDoesTitle => 'BeneathSOS ne yapar';

  @override
  String get noticeDoesBody =>
      'Bir telefonun Bluetooth sinyalini birkaç noktada ölçer ve telefonun en olası bulunduğu alanı gösterir — bir alan, asla kesin bir nokta değil.';

  @override
  String get noticeDoesNotTitle => 'Ne yapmaz';

  @override
  String get noticeDoesNotBody =>
      'Profesyonel kurtarmanın yerini tutmaz. 112\'yi arayın; AFAD\'a ve sahadaki kurtarma ekiplerine uyun.';

  @override
  String get noticeAccept => 'Anladım';

  @override
  String get siteTitle => 'Enkaz alanı';

  @override
  String get siteHint => 'Enkazın çevresinde yürüyün ve her köşeye dokunun.';

  @override
  String siteSummary(String width, String depth) {
    return '4 köşe · $width × $depth m';
  }

  @override
  String get siteDone => 'Çizim tamam';

  @override
  String get scanTitle => 'Ortam taraması';

  @override
  String get scanStand => 'Enkazdan 10 m uzakta durun.';

  @override
  String get scanBody =>
      'Yüzeydeki telefonlar — kurtarıcılar, çevredekiler — şimdi listeleniyor ve hedef olarak önerilmeyecek.';

  @override
  String get scanFound => 'Yüzeyde bulunan telefonlar';

  @override
  String get scanContinue => 'Devam et';

  @override
  String secondsLeft(int seconds) {
    return '$seconds saniye kaldı';
  }

  @override
  String get targetTitle => 'Hedefi seçin';

  @override
  String get targetHint =>
      'Bir kurtarıcının telefonunu sizinkine yaklaştırın; listeden çıkar.';

  @override
  String get targetSamsung => 'Samsung telefon';

  @override
  String get targetUnknown => 'Bilinmeyen cihaz';

  @override
  String get targetReasonLikely =>
      'Kıpırdamıyor · zayıf sinyal · yüzeyde görülmedi';

  @override
  String get targetReasonMedium => 'Kıpırdamıyor · orta sinyal';

  @override
  String get targetReasonMoving => 'Hareket ediyor — büyük olasılıkla yüzeyde';

  @override
  String get targetTrack => 'Bu telefonu izle';

  @override
  String get measureTitle => 'Nokta 3 / 5';

  @override
  String get measureHold => 'Telefonu bu noktada sabit tutun.';

  @override
  String get measureHeard => 'Sinyal var: −71 dBm.';

  @override
  String get measureStill => 'Telefon sabit.';

  @override
  String get measureShowMap => 'Haritayı göster';

  @override
  String get measureDiscard => 'Bu noktayı sil';

  @override
  String get mapTitle => 'Olasılık haritası';

  @override
  String get mapRotation =>
      'Bluetooth kimliği yaklaşık 2 dk içinde değişecek. Enkazın yakınında kalın.';

  @override
  String get mapMostLikely => 'En olası bölge · %50';

  @override
  String get mapRegion90 => '%90';

  @override
  String get mapHeard => 'sinyal var';

  @override
  String get mapNoSignal => 'sinyal yok';

  @override
  String get mapNext => 'önerilen sonraki nokta';

  @override
  String get mapMeasure => 'Burada ölç';

  @override
  String get victimSending => 'Telefonunuz yardım sinyali gönderiyor.';

  @override
  String get victimCalm => 'Sakin olun. Pilinizi koruyun.';

  @override
  String get victimTap => 'Kurtarıcıları duyduğunuzda ekrana 3 kez dokunun.';

  @override
  String get victimBattery => 'Pil';

  @override
  String get victimSos => 'SOS sesi çal';
}
