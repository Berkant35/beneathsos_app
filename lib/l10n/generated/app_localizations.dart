import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BeneathSOS'**
  String get appTitle;

  /// No description provided for @fieldTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Field test'**
  String get fieldTestTitle;

  /// No description provided for @scanStart.
  ///
  /// In en, this message translates to:
  /// **'Start scan'**
  String get scanStart;

  /// No description provided for @scanStop.
  ///
  /// In en, this message translates to:
  /// **'Stop scan'**
  String get scanStop;

  /// No description provided for @scanStateIdle.
  ///
  /// In en, this message translates to:
  /// **'Scanner stopped'**
  String get scanStateIdle;

  /// No description provided for @scanStateRunning.
  ///
  /// In en, this message translates to:
  /// **'Scanning — {devices} devices, {rate} samples/s'**
  String scanStateRunning(int devices, int rate);

  /// No description provided for @scanStateNeedsPermission.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth / location permission is needed to scan.'**
  String get scanStateNeedsPermission;

  /// No description provided for @scanStateBluetoothOff.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth is off. Turn it on to scan.'**
  String get scanStateBluetoothOff;

  /// No description provided for @scanStateFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan failed: {reason}'**
  String scanStateFailed(String reason);

  /// No description provided for @actionGrantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant permission'**
  String get actionGrantPermission;

  /// No description provided for @actionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get actionOpenSettings;

  /// No description provided for @filterMinRssi.
  ///
  /// In en, this message translates to:
  /// **'Min RSSI: {value} dBm'**
  String filterMinRssi(int value);

  /// No description provided for @filterAppleOnly.
  ///
  /// In en, this message translates to:
  /// **'Apple only'**
  String get filterAppleOnly;

  /// No description provided for @filterTargetsOnly.
  ///
  /// In en, this message translates to:
  /// **'Targets only'**
  String get filterTargetsOnly;

  /// No description provided for @tabDevices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get tabDevices;

  /// No description provided for @tabEvents.
  ///
  /// In en, this message translates to:
  /// **'Identity log'**
  String get tabEvents;

  /// No description provided for @emptyDevices.
  ///
  /// In en, this message translates to:
  /// **'No devices yet. Keep the scanner running.'**
  String get emptyDevices;

  /// No description provided for @emptyEvents.
  ///
  /// In en, this message translates to:
  /// **'No devices appeared or disappeared yet.'**
  String get emptyEvents;

  /// No description provided for @kindAppleFindMy.
  ///
  /// In en, this message translates to:
  /// **'Apple · Find My'**
  String get kindAppleFindMy;

  /// No description provided for @kindAppleNearby.
  ///
  /// In en, this message translates to:
  /// **'Apple · Nearby'**
  String get kindAppleNearby;

  /// No description provided for @kindAppleOther.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get kindAppleOther;

  /// No description provided for @kindSamsung.
  ///
  /// In en, this message translates to:
  /// **'Samsung'**
  String get kindSamsung;

  /// No description provided for @kindMicrosoft.
  ///
  /// In en, this message translates to:
  /// **'Microsoft'**
  String get kindMicrosoft;

  /// No description provided for @kindGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get kindGoogle;

  /// No description provided for @kindOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get kindOther;

  /// No description provided for @kindUnknown.
  ///
  /// In en, this message translates to:
  /// **'No manufacturer data'**
  String get kindUnknown;

  /// No description provided for @lastSeenSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s ago'**
  String lastSeenSeconds(int seconds);

  /// No description provided for @rssiValue.
  ///
  /// In en, this message translates to:
  /// **'{value} dBm'**
  String rssiValue(int value);

  /// No description provided for @noValue.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get noValue;

  /// No description provided for @statNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get statNow;

  /// No description provided for @statMedian5.
  ///
  /// In en, this message translates to:
  /// **'Median 5 s'**
  String get statMedian5;

  /// No description provided for @statMedian15.
  ///
  /// In en, this message translates to:
  /// **'Median 15 s'**
  String get statMedian15;

  /// No description provided for @statStdDev15.
  ///
  /// In en, this message translates to:
  /// **'Std dev 15 s'**
  String get statStdDev15;

  /// No description provided for @statRate.
  ///
  /// In en, this message translates to:
  /// **'Samples/s'**
  String get statRate;

  /// No description provided for @statCount.
  ///
  /// In en, this message translates to:
  /// **'Total samples'**
  String get statCount;

  /// No description provided for @detailFirstSeen.
  ///
  /// In en, this message translates to:
  /// **'Same identity for {elapsed}'**
  String detailFirstSeen(String elapsed);

  /// No description provided for @detailRotationHint.
  ///
  /// In en, this message translates to:
  /// **'Phones change their Bluetooth identity about every 15 minutes. Finish measurements before that.'**
  String get detailRotationHint;

  /// No description provided for @detailGone.
  ///
  /// In en, this message translates to:
  /// **'Not seen for {seconds} s — the identity may have changed.'**
  String detailGone(int seconds);

  /// No description provided for @detailPayload.
  ///
  /// In en, this message translates to:
  /// **'Last manufacturer data'**
  String get detailPayload;

  /// No description provided for @detailCompany.
  ///
  /// In en, this message translates to:
  /// **'Company ID'**
  String get detailCompany;

  /// No description provided for @detailName.
  ///
  /// In en, this message translates to:
  /// **'Advertised name'**
  String get detailName;

  /// No description provided for @targetSet.
  ///
  /// In en, this message translates to:
  /// **'Mark as target'**
  String get targetSet;

  /// No description provided for @targetUnset.
  ///
  /// In en, this message translates to:
  /// **'Remove target'**
  String get targetUnset;

  /// No description provided for @relinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Possible new identity'**
  String get relinkTitle;

  /// No description provided for @relinkBody.
  ///
  /// In en, this message translates to:
  /// **'Appeared {seconds} s after the target disappeared, RSSI difference {delta} dB.'**
  String relinkBody(int seconds, int delta);

  /// No description provided for @relinkAccept.
  ///
  /// In en, this message translates to:
  /// **'Use as target'**
  String get relinkAccept;

  /// No description provided for @eventAppeared.
  ///
  /// In en, this message translates to:
  /// **'Appeared'**
  String get eventAppeared;

  /// No description provided for @eventGone.
  ///
  /// In en, this message translates to:
  /// **'Disappeared'**
  String get eventGone;

  /// No description provided for @recordStart.
  ///
  /// In en, this message translates to:
  /// **'Record CSV'**
  String get recordStart;

  /// No description provided for @recordStop.
  ///
  /// In en, this message translates to:
  /// **'Stop recording'**
  String get recordStop;

  /// No description provided for @recordRunning.
  ///
  /// In en, this message translates to:
  /// **'Recording · {count} samples · {elapsed}'**
  String recordRunning(int count, String elapsed);

  /// No description provided for @recordShare.
  ///
  /// In en, this message translates to:
  /// **'Share last recording'**
  String get recordShare;

  /// No description provided for @markerAdd.
  ///
  /// In en, this message translates to:
  /// **'Add marker'**
  String get markerAdd;

  /// No description provided for @markerHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. P1 · 1 m · under concrete'**
  String get markerHint;

  /// No description provided for @markerSaved.
  ///
  /// In en, this message translates to:
  /// **'Marker saved'**
  String get markerSaved;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Research tool. Signal strength never proves a location.'**
  String get disclaimer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
