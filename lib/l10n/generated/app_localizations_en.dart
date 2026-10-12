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

  @override
  String get readinessFailed => 'Could not check Bluetooth. Tap to try again.';

  @override
  String get previewBanner => 'Preview — sample data, no real measurement.';

  @override
  String get noticeTitle => 'Before you start';

  @override
  String get noticeDoesTitle => 'What BeneathSOS does';

  @override
  String get noticeDoesBody =>
      'It measures the Bluetooth signal of a phone at several points and shows the area where it most likely is — an area, never an exact spot.';

  @override
  String get noticeDoesNotTitle => 'What it does not do';

  @override
  String get noticeDoesNotBody =>
      'It does not replace professional rescue. Call 112 and follow AFAD and the rescue teams on site.';

  @override
  String get noticeAccept => 'I understand';

  @override
  String get siteTitle => 'Rubble site';

  @override
  String get siteHint => 'Walk around the rubble and tap each corner.';

  @override
  String siteSummary(String width, String depth) {
    return '4 corners · $width × $depth m';
  }

  @override
  String get siteDone => 'Outline done';

  @override
  String get scanTitle => 'Ambient scan';

  @override
  String get scanStand => 'Stand 10 m away from the rubble.';

  @override
  String get scanBody =>
      'Phones on the surface — rescuers, bystanders — are listed now and will not be suggested as targets.';

  @override
  String get scanFound => 'Surface phones found';

  @override
  String get scanContinue => 'Continue';

  @override
  String secondsLeft(int seconds) {
    return '$seconds seconds left';
  }

  @override
  String get targetTitle => 'Choose the target';

  @override
  String get targetHint =>
      'Hold a rescuer\'s phone next to yours to exclude it.';

  @override
  String get targetSamsung => 'Samsung phone';

  @override
  String get targetUnknown => 'Unknown device';

  @override
  String get targetReasonLikely =>
      'Not moving · weak signal · not seen on the surface';

  @override
  String get targetReasonMedium => 'Not moving · medium signal';

  @override
  String get targetReasonMoving => 'Moving — probably on the surface';

  @override
  String get targetTrack => 'Track this phone';

  @override
  String get measureTitle => 'Point 3 of 5';

  @override
  String get measureHold => 'Hold the phone still at this point.';

  @override
  String get measureHeard => 'Signal heard: −71 dBm.';

  @override
  String get measureStill => 'The phone is still.';

  @override
  String get measureShowMap => 'Show the map';

  @override
  String get measureDiscard => 'Discard this point';

  @override
  String get mapTitle => 'Probability map';

  @override
  String get mapRotation =>
      'Its Bluetooth identity changes in about 2 min. Stay near the rubble.';

  @override
  String get mapMostLikely => 'Most likely area · 50 %';

  @override
  String get mapRegion90 => '90 %';

  @override
  String get mapHeard => 'signal heard';

  @override
  String get mapNoSignal => 'no signal';

  @override
  String get mapNext => 'suggested next point';

  @override
  String get mapMeasure => 'Measure here';

  @override
  String get victimSending => 'Your phone is sending a help signal.';

  @override
  String get victimCalm => 'Stay calm. Save your battery.';

  @override
  String get victimTap => 'When you hear rescuers, tap the screen 3 times.';

  @override
  String get victimBattery => 'Battery';

  @override
  String get victimSos => 'Play SOS sound';

  @override
  String get practiceTitle => 'Practice search';

  @override
  String get lastSearchTitle => 'Last search';

  @override
  String get lastPracticeTitle => 'Last practice search';

  @override
  String lastSearchBody(String title, int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points measured',
      one: '1 point measured',
      zero: 'no point measured yet',
    );
    return '$title · $_temp0 · started $time';
  }

  @override
  String get lastSearchContinue => 'Continue the search';

  @override
  String get lastSearchFinish => 'Finish this search';
}
