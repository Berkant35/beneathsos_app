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
  String get fieldTestTitle => 'Field test';

  @override
  String get scanStart => 'Start scan';

  @override
  String get scanStop => 'Stop scan';

  @override
  String get scanStateIdle => 'Scanner stopped';

  @override
  String scanStateRunning(int devices, int rate) {
    return 'Scanning — $devices devices, $rate samples/s';
  }

  @override
  String get scanStateNeedsPermission =>
      'Bluetooth / location permission is needed to scan.';

  @override
  String get scanStateBluetoothOff => 'Bluetooth is off. Turn it on to scan.';

  @override
  String scanStateFailed(String reason) {
    return 'Scan failed: $reason';
  }

  @override
  String get actionGrantPermission => 'Grant permission';

  @override
  String get actionOpenSettings => 'Open settings';

  @override
  String filterMinRssi(int value) {
    return 'Min RSSI: $value dBm';
  }

  @override
  String get filterAppleOnly => 'Apple only';

  @override
  String get filterTargetsOnly => 'Targets only';

  @override
  String get tabDevices => 'Devices';

  @override
  String get tabEvents => 'Identity log';

  @override
  String get emptyDevices => 'No devices yet. Keep the scanner running.';

  @override
  String get emptyEvents => 'No devices appeared or disappeared yet.';

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
  String get kindOther => 'Other';

  @override
  String get kindUnknown => 'No manufacturer data';

  @override
  String lastSeenSeconds(int seconds) {
    return '$seconds s ago';
  }

  @override
  String rssiValue(int value) {
    return '$value dBm';
  }

  @override
  String get noValue => '—';

  @override
  String get statNow => 'Now';

  @override
  String get statMedian5 => 'Median 5 s';

  @override
  String get statMedian15 => 'Median 15 s';

  @override
  String get statStdDev15 => 'Std dev 15 s';

  @override
  String get statRate => 'Samples/s';

  @override
  String get statCount => 'Total samples';

  @override
  String detailFirstSeen(String elapsed) {
    return 'Same identity for $elapsed';
  }

  @override
  String get detailRotationHint =>
      'Phones change their Bluetooth identity about every 15 minutes. Finish measurements before that.';

  @override
  String detailGone(int seconds) {
    return 'Not seen for $seconds s — the identity may have changed.';
  }

  @override
  String get detailPayload => 'Last manufacturer data';

  @override
  String get detailCompany => 'Company ID';

  @override
  String get detailName => 'Advertised name';

  @override
  String get targetSet => 'Mark as target';

  @override
  String get targetUnset => 'Remove target';

  @override
  String get relinkTitle => 'Possible new identity';

  @override
  String relinkBody(int seconds, int delta) {
    return 'Appeared $seconds s after the target disappeared, RSSI difference $delta dB.';
  }

  @override
  String get relinkAccept => 'Use as target';

  @override
  String get eventAppeared => 'Appeared';

  @override
  String get eventGone => 'Disappeared';

  @override
  String get recordStart => 'Record CSV';

  @override
  String get recordStop => 'Stop recording';

  @override
  String recordRunning(int count, String elapsed) {
    return 'Recording · $count samples · $elapsed';
  }

  @override
  String get recordShare => 'Share last recording';

  @override
  String get markerAdd => 'Add marker';

  @override
  String get markerHint => 'e.g. P1 · 1 m · under concrete';

  @override
  String get markerSaved => 'Marker saved';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionSave => 'Save';

  @override
  String get disclaimer =>
      'Research tool. Signal strength never proves a location.';
}
