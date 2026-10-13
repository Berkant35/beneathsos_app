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
  String get victimSending => 'Telefonunuz kurtarıcılara sinyal gönderiyor.';

  @override
  String get victimCalm =>
      'Sakin olun. Bu ekranı açık tutun — pil için karanlık kalır.';

  @override
  String get victimTap =>
      'Arada bir ekrana dokunun: kurtarıcılar telefona yakın zamanda dokunulduğunu ya da kıpırdatıldığını görür.';

  @override
  String get victimSos => 'SOS sesi çal';

  @override
  String get practiceTitle => 'Alıştırma araması';

  @override
  String get lastSearchTitle => 'Son arama';

  @override
  String get lastPracticeTitle => 'Son alıştırma araması';

  @override
  String lastSearchBody(String title, int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nokta ölçüldü',
      zero: 'henüz ölçülen nokta yok',
    );
    return '$title · $_temp0 · başlangıç $time';
  }

  @override
  String get lastSearchContinue => 'Aramaya devam et';

  @override
  String get lastSearchFinish => 'Bu aramayı bitir';

  @override
  String lastSearchUnreadable(String title, String time) {
    return '$title · verilerinin bir kısmı okunamadı · başlangıç $time';
  }

  @override
  String get finishConfirmTitle => 'Bu arama bitirilsin mi?';

  @override
  String get finishConfirmBody =>
      'Bu aramaya bir daha devam edemezsiniz. Kaydedilen her şey saklanır.';

  @override
  String get finishConfirmYes => 'Bitir';

  @override
  String get finishConfirmNo => 'Açık kalsın';

  @override
  String get sitesTitle => 'Aramalar';

  @override
  String get sitesNew => 'Yeni arama';

  @override
  String get sitesEmpty => 'Henüz arama yok.';

  @override
  String get sitesPractice => 'Örnek verilerle alıştırma yap';

  @override
  String get sitesLoadFailed => 'Aramalar yüklenemedi. Hiçbir şey silinmedi.';

  @override
  String searchTileBody(int count, String started) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nokta ölçüldü',
      zero: 'henüz ölçülen nokta yok',
    );
    return '$_temp0 · başlangıç $started';
  }

  @override
  String searchTileUnreadable(String started) {
    return 'verilerinin bir kısmı okunamadı · başlangıç $started';
  }

  @override
  String get searchFinished => 'Bitti';

  @override
  String get newSiteTitle => 'Yeni arama';

  @override
  String get newSiteLabel => 'Alanın adı';

  @override
  String get newSiteHint => 'ör. Atatürk Cad. 12, Antakya';

  @override
  String get newSiteEmpty => 'Bu aramayı sonra bulabilmek için bir ad girin.';

  @override
  String get newSiteTooLong => 'En fazla 80 karakter kullanın.';

  @override
  String get newSiteCreate => 'Aramayı oluştur';

  @override
  String get searchTitle => 'Arama';

  @override
  String siteStarted(String started) {
    return 'Başlangıç: $started';
  }

  @override
  String get siteStepOutline => 'Enkazın sınırını çizin';

  @override
  String get siteStepAmbient => 'Yüzeydeki telefonları bulun';

  @override
  String get siteStepTarget => 'Aranacak telefonu seçin';

  @override
  String get siteStepMeasure => 'Enkazın çevresinde noktalarda ölçüm yapın';

  @override
  String get siteStepDone => 'Tamamlandı';

  @override
  String get siteStepNext => 'Sonraki güncellemede';

  @override
  String siteMeasuredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nokta ölçüldü',
    );
    return '$_temp0';
  }

  @override
  String get siteFinished => 'Bu arama bitti. Verileri saklanıyor.';

  @override
  String get siteUnreadable =>
      'Bu aramanın verilerinin bir kısmı okunamadı. Hiçbir şey silinmedi.';

  @override
  String get siteNotFound => 'Bu arama açılamadı.';

  @override
  String get siteBackToList => 'Aramalara dön';

  @override
  String get newSiteFailed =>
      'Arama kaydedilemedi. Biraz sonra yeniden deneyin.';

  @override
  String get finishFailed => 'Arama bitirilemedi. Biraz sonra yeniden deneyin.';

  @override
  String get drawTitle => 'Enkazın sınırı';

  @override
  String get drawHint =>
      'Enkazın her köşesine dokunun. Taşımak için köşeyi sürükleyin.';

  @override
  String get drawUndo => 'Geri al';

  @override
  String get drawClear => 'Temizle';

  @override
  String drawSummary(int corners, String perimeter, String area) {
    return '$corners köşe · çevre $perimeter · alan $area';
  }

  @override
  String get drawTooFew => 'En az 3 köşeye dokunun.';

  @override
  String get drawTooClose =>
      'İki köşe neredeyse üst üste. Birini uzaklaştırın.';

  @override
  String get drawCrossing =>
      'İki kenar kesişiyor. Kesişmesinler diye bir köşeyi sürükleyin.';

  @override
  String get drawNoArea => 'Çizimin alanı yok. Köşeleri birbirinden ayırın.';

  @override
  String get drawBadCorner =>
      'Bir köşe yerleştirilemedi. Son değişikliği geri alın.';

  @override
  String get drawNotSaved =>
      'Çizim kaydedilemedi. Biraz sonra yeniden deneyin.';

  @override
  String get drawLoadFailed => 'Bu çizim açılamadı. Hiçbir şey silinmedi.';

  @override
  String get clearConfirmTitle => 'Çizim temizlensin mi?';

  @override
  String get clearConfirmBody => 'Tüm köşeler silinir. Geri alabilirsiniz.';

  @override
  String get clearConfirmYes => 'Temizle';

  @override
  String get clearConfirmNo => 'Kalsın';

  @override
  String lengthMetres(String value) {
    return '$value m';
  }

  @override
  String areaSquareMetres(String value) {
    return '$value m²';
  }

  @override
  String get scaleTitle => 'Gerçek boyut';

  @override
  String get scaleQuestion => 'İşaretli kenar gerçekte ne kadar uzun?';

  @override
  String get scalePickHint => 'Başka bir kenarı ölçmek için ona dokunun.';

  @override
  String scaleNow(String length) {
    return 'Şu an $length görünüyor';
  }

  @override
  String get scaleLabel => 'Metre cinsinden gerçek uzunluk';

  @override
  String get scaleHowTitle => 'Nasıl ölçtünüz?';

  @override
  String get scaleTape => 'Şerit metre';

  @override
  String get scaleSteps => 'Adımlayarak';

  @override
  String get scaleEstimate => 'Tahmin';

  @override
  String get scaleSave => 'Boyutu kaydet';

  @override
  String get scaleSkip => 'Atla';

  @override
  String get scaleNotANumber => 'Bir sayı girin, örneğin 18,5.';

  @override
  String get scaleOutOfRange => '0,5 ile 500 m arasında bir uzunluk girin.';

  @override
  String get scaleNotSaved =>
      'Boyut kaydedilemedi. Biraz sonra yeniden deneyin.';

  @override
  String siteOutlineDone(String area) {
    return 'Tamamlandı · $area';
  }

  @override
  String get siteStepStart => 'Başlamak için dokunun';

  @override
  String get siteStepNotDone => 'Yapılmadı';

  @override
  String get leaveDrawTitle => 'Kaydetmeden çıkılsın mı?';

  @override
  String get leaveDrawBody => 'Son kayıttan sonra çizilen köşeler kaybolur.';

  @override
  String get leaveDrawStay => 'Çizmeye devam et';

  @override
  String get leaveDrawLeave => 'Çık';

  @override
  String get scaleConfirmTitle => 'Bu doğru mu?';

  @override
  String scaleConfirmBody(String factor, String real) {
    return 'Tüm uzunluklar çizdiğinizin $factor katı olur: bu kenar $real olur. Sayıyı kontrol edin.';
  }

  @override
  String get scaleConfirmFix => 'Düzelt';

  @override
  String get scaleConfirmSave => 'Yine de kaydet';

  @override
  String get unitMetres => 'm';

  @override
  String get scaleNoOutline => 'Önce sınırı çizin.';

  @override
  String get ambientTitle => 'Yüzeydeki telefonlar';

  @override
  String ambientHeard(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Şimdiye kadar $count telefon duyuldu',
      zero: 'Henüz telefon duyulmadı',
    );
    return '$_temp0';
  }

  @override
  String ambientDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yüzey telefonu ayrıldı. Hedef olarak önerilmeyecekler.',
      zero: 'Yakında telefon yok: hiçbiri ayrılmadı.',
    );
    return '$_temp0';
  }

  @override
  String get ambientNotSaved => 'Tarama kaydedilemedi. Yeniden tarayın.';

  @override
  String get ambientAgain => 'Yeniden tara';

  @override
  String get ambientChoose => 'Telefonu seç';

  @override
  String get ambientBack => 'Aramaya dön';

  @override
  String get targetsHintExclude =>
      'Bir ekip telefonunu sizinkinin yanına tutun: çok güçlü olan kart o telefondur — onu hariç tutun.';

  @override
  String get targetsNoSurfaceScan =>
      'Henüz yüzey taraması yok: kurtarıcıların telefonları listelenebilir. Önce taramak için dokunun.';

  @override
  String get targetsNone => 'Henüz telefon duyulmadı. Bu ekranı açık tutun.';

  @override
  String get reasonNotMoving => 'Hareketsiz';

  @override
  String get reasonWeak => 'zayıf sinyal';

  @override
  String get reasonMedium => 'orta sinyal';

  @override
  String get reasonNotOnSurface => 'yüzey taramasında güçlü değildi';

  @override
  String get reasonVeryStrong =>
      'Çok güçlü sinyal — bir ekip telefonuysa hariç tutun';

  @override
  String targetSignal(String value) {
    return 'Sinyal $value dBm';
  }

  @override
  String get targetExclude => 'Hariç tut — yüzeyde';

  @override
  String get targetNotSaved => 'Kaydedilemedi. Biraz sonra yeniden deneyin.';

  @override
  String get kindFindMy => 'Apple · Bul';

  @override
  String get kindApple => 'Apple cihazı';

  @override
  String get kindWindows => 'Windows cihazı';

  @override
  String get kindGoogle => 'Android cihazı (Google)';

  @override
  String get kindOther => 'Bluetooth cihazı';

  @override
  String siteAmbientDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tamamlandı · $count telefon ayrıldı',
      zero: 'Tamamlandı · hiçbiri ayrılmadı',
    );
    return '$_temp0';
  }

  @override
  String siteTargetDone(String label) {
    return 'Tamamlandı · $label';
  }

  @override
  String get reasonChanging => 'Sinyal değişiyor — hareket ediyor olabilir';

  @override
  String get reasonFewReadings => 'Şimdiye kadar az duyuldu';

  @override
  String targetsSurfaceScanOld(int minutes) {
    return 'Yüzey taraması $minutes dk önce yapıldı: telefonlar Bluetooth kimliklerini yaklaşık 15 dakikada bir değiştirir. Yeniden taramak için dokunun.';
  }

  @override
  String excludeDone(String label) {
    return 'Ayrıldı: $label.';
  }

  @override
  String setAsideTitle(int count) {
    return 'Ayrılanlar ($count)';
  }

  @override
  String get putBack => 'Geri koy';

  @override
  String get setAsideNotHeard => 'Şu an duyulmuyor';

  @override
  String get sortAgain => 'Yeniden sırala';

  @override
  String get scanFailed => 'Tarama durdu. Yeniden denemek için dokunun.';

  @override
  String get pointTitle => 'Ölçüm';

  @override
  String get pointChoose =>
      'Enkazın çevresinde bir yerde durun ve haritada bulunduğunuz yere dokunun.';

  @override
  String pointSummary(int count, int heard) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nokta ölçüldü',
      zero: 'Henüz ölçülen nokta yok',
    );
    return '$_temp0 · $heard tanesinde sinyal var';
  }

  @override
  String get pointMoving =>
      'Hareket var — telefon sabit olana kadar sayım bekliyor.';

  @override
  String pointHeard(String label) {
    return '$label: sinyal var';
  }

  @override
  String pointNotYet(String label) {
    return '$label: henüz duyulmadı';
  }

  @override
  String pointSavedHeard(String value) {
    return 'Nokta kaydedildi: sinyal var ($value dBm).';
  }

  @override
  String get pointSavedNotHeard =>
      'Nokta kaydedildi: duyulmadı — bu da bir bilgi.';

  @override
  String get pointNotSaved => 'Nokta kaydedilemedi. Yeniden ölçün.';

  @override
  String get pointNeedsOutline => 'Önce enkazın sınırını çizin.';

  @override
  String get pointNeedsTarget => 'Önce aranacak telefonu seçin.';

  @override
  String relinkQuestion(String label, int seconds) {
    return '$label Bluetooth kimliğini değiştirmiş olabilir: susmasından $seconds sn sonra benzer sinyalli yeni bir kimlik çıktı. Aynı telefon mu?';
  }

  @override
  String get relinkYes => 'Evet, aynı telefon';

  @override
  String get mapLegend =>
      'Dolu: sinyal var · Halka: duyulmadı · Turuncu: şimdi ölçülüyor';

  @override
  String get pointRadioSilent =>
      'Hiçbir Bluetooth cihazı duyulmadı — tarama çalışmıyordu. Nokta kaydedilmedi; yeniden ölçün.';

  @override
  String get pointStart => 'Burada ölç';

  @override
  String get pointMoveHint => 'Noktayı taşımak için haritaya yeniden dokunun.';

  @override
  String get pointSaving => 'Nokta kaydediliyor…';

  @override
  String get relinkNo => 'Hayır, bu değil';

  @override
  String get probTitle => 'Olasılık haritası';

  @override
  String probAreas(String area50, String area90) {
    return 'En olası alan: $area50 (%50) · $area90 (%90)';
  }

  @override
  String probLowInfo(int count) {
    return 'Bilgi yetersiz: sinyal alınan yer $count\'ten az. Enkazın çevresinde daha fazla nokta ölçün.';
  }

  @override
  String get probNeedsPoint => 'Önce enkazın çevresinde en az bir nokta ölçün.';

  @override
  String get probCalculating => 'Harita hesaplanıyor…';

  @override
  String get probFailed => 'Harita hesaplanamadı. Hiçbir şey silinmedi.';

  @override
  String get probMeasureNext => 'Sonraki noktayı ölç';

  @override
  String get probLegend =>
      'Yoğun renk: en olası %50 · Soluk renk: %90 · Halka: önerilen sonraki nokta';

  @override
  String get probRule =>
      'Bu, telefonun büyük olasılıkla bulunduğu bir alandır — asla kesin bir nokta değil.';

  @override
  String get siteOpenMap => 'Olasılık haritasını aç';

  @override
  String probOnRubble(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Enkazın üstündeki $count nokta kullanılmadı',
      one: 'Enkazın üstündeki 1 nokta kullanılmadı',
    );
    return '$_temp0: harita, çevresinde ölçülen noktalarla çalışır.';
  }

  @override
  String get victimStarting => 'Yardım sinyali başlatılıyor…';

  @override
  String victimSignalName(String name) {
    return 'Sinyal adı: $name';
  }

  @override
  String victimBatteryValue(int percent) {
    return 'Pil: %$percent';
  }

  @override
  String get victimNeedsPermission =>
      'Kurtarıcıların bu telefonu bulabilmesi için Bluetooth\'a izin verin.';

  @override
  String get victimAllow => 'Bluetooth\'a izin ver';

  @override
  String get victimNeedsSettings =>
      'BeneathSOS için Bluetooth erişimi kapalı. Ayarlar\'dan açın.';

  @override
  String get victimOpenSettings => 'Ayarlar\'ı aç';

  @override
  String get victimBluetoothOff =>
      'Kurtarıcıların bu telefonu bulabilmesi için Bluetooth\'u açın.';

  @override
  String get victimUnsupported =>
      'Bu telefon Bluetooth yardım sinyali gönderemiyor. SOS sesini kullanın.';

  @override
  String get victimFailed => 'Yardım sinyali durdu.';

  @override
  String get victimRetry => 'Tekrar dene';

  @override
  String get victim112 => 'Mobil şebeke varsa 112\'yi arayın.';

  @override
  String get victimSosStop => 'SOS sesini durdur';

  @override
  String get victimStopTitle => 'Sinyal durdurulsun mu?';

  @override
  String get victimStopBody =>
      'Kurtarıcılar bu telefonu artık sinyalinden bulamaz.';

  @override
  String get victimKeep => 'Sinyale devam et';

  @override
  String get victimStop => 'Durdur';

  @override
  String get kindTrapped => 'BeneathSOS: “Enkaz altındayım”';

  @override
  String get reasonTrapped => 'Bu telefon enkaz altında olduğunu bildiriyor';

  @override
  String reasonBattery(int percent) {
    return 'pil %$percent';
  }

  @override
  String reasonTouched(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes dk önce kıpırdatıldı ya da dokunuldu',
      zero: 'son bir dakikada kıpırdatıldı ya da dokunuldu',
    );
    return '$_temp0';
  }

  @override
  String get reasonUntouched =>
      '4 saatten uzun süredir kıpırdatılmadı, dokunulmadı';

  @override
  String get exportTitle => 'Bu aramayı dışa aktar';

  @override
  String get exportContents =>
      'İki dosya: kaydedildiği hâliyle arama (her adım, nokta ve ölçüm ile bu uyarı) ve ham sinyal ölçümleri. Hedef olmayan telefonlar yalnızca geri izlenemeyen kodlarla görünür. Dosyaların nereye gideceğini siz seçersiniz.';

  @override
  String get exportShare => 'Dışa aktar ve paylaş';

  @override
  String get exportDone =>
      'Paylaşıldı. Dosyalar bu aramayı kaydedildiği hâliyle içerir.';

  @override
  String get exportFailed => 'Dışa aktarılamadı. Hiçbir şey değişmedi.';

  @override
  String get siteExport => 'Bu aramayı dışa aktar';

  @override
  String get victimSosHint => 'Sesi sonuna kadar açın.';

  @override
  String get probRecordFound => 'Bulunduğu yeri kaydet';

  @override
  String get probTapFound => 'Haritada telefonun bulunduğu yere dokunun.';

  @override
  String get probFound50 => '%50 alanının içinde bulundu.';

  @override
  String get probFound90 => '%90 alanının içinde bulundu.';

  @override
  String probFoundOutside(String distance) {
    return '%90 alanının dışında, ondan $distance uzakta bulundu.';
  }

  @override
  String get probRecordFailed => 'Bulunduğu yer kaydedilemedi. Tekrar deneyin.';

  @override
  String get probConfirmFoundTitle =>
      'Telefon burada bulundu olarak kaydedilsin mi?';

  @override
  String get probConfirmFoundBody =>
      'Bu aramadaki herkes onu burada bulunmuş görür. Yalnızca telefon elinizdeyken kaydedin.';

  @override
  String get probConfirmFoundYes => 'Kaydet';

  @override
  String get probConfirmFoundNo => 'Burada değil';

  @override
  String get probCancel => 'Vazgeç';
}
