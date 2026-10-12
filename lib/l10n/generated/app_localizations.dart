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

  /// No description provided for @logoLabel.
  ///
  /// In en, this message translates to:
  /// **'BeneathSOS'**
  String get logoLabel;

  /// No description provided for @homeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Search for a phone under rubble'**
  String get homeHeadline;

  /// No description provided for @homeBody.
  ///
  /// In en, this message translates to:
  /// **'Measure the phone\'s Bluetooth signal at a few points; the app shows the most likely area.'**
  String get homeBody;

  /// No description provided for @homeStartSearch.
  ///
  /// In en, this message translates to:
  /// **'Start a search'**
  String get homeStartSearch;

  /// No description provided for @homeTrapped.
  ///
  /// In en, this message translates to:
  /// **'I am trapped'**
  String get homeTrapped;

  /// No description provided for @homeIndependence.
  ///
  /// In en, this message translates to:
  /// **'BeneathSOS is an independent open-source project and is not affiliated with AFAD or any government agency.'**
  String get homeIndependence;

  /// No description provided for @poweredBy.
  ///
  /// In en, this message translates to:
  /// **'Powered by Socrepho'**
  String get poweredBy;

  /// No description provided for @victimTitle.
  ///
  /// In en, this message translates to:
  /// **'I am trapped'**
  String get victimTitle;

  /// No description provided for @victimPreparing.
  ///
  /// In en, this message translates to:
  /// **'This mode is not ready yet. In an emergency, call 112.'**
  String get victimPreparing;

  /// No description provided for @readinessChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking Bluetooth…'**
  String get readinessChecking;

  /// No description provided for @readinessReady.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth is on and ready.'**
  String get readinessReady;

  /// No description provided for @readinessNeedsPermission.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth permission is needed. Tap to allow it.'**
  String get readinessNeedsPermission;

  /// No description provided for @readinessPermissionInSettings.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth permission is off. Tap to turn it on in Settings.'**
  String get readinessPermissionInSettings;

  /// No description provided for @readinessBluetoothOff.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth is off. Turn it on in your phone\'s settings.'**
  String get readinessBluetoothOff;

  /// No description provided for @readinessUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This phone does not support Bluetooth LE. Search with another phone.'**
  String get readinessUnsupported;

  /// No description provided for @preparingCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Being prepared'**
  String get preparingCardTitle;

  /// No description provided for @readinessFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not check Bluetooth. Tap to try again.'**
  String get readinessFailed;

  /// No description provided for @previewBanner.
  ///
  /// In en, this message translates to:
  /// **'Preview — sample data, no real measurement.'**
  String get previewBanner;

  /// No description provided for @noticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get noticeTitle;

  /// No description provided for @noticeDoesTitle.
  ///
  /// In en, this message translates to:
  /// **'What BeneathSOS does'**
  String get noticeDoesTitle;

  /// No description provided for @noticeDoesBody.
  ///
  /// In en, this message translates to:
  /// **'It measures the Bluetooth signal of a phone at several points and shows the area where it most likely is — an area, never an exact spot.'**
  String get noticeDoesBody;

  /// No description provided for @noticeDoesNotTitle.
  ///
  /// In en, this message translates to:
  /// **'What it does not do'**
  String get noticeDoesNotTitle;

  /// No description provided for @noticeDoesNotBody.
  ///
  /// In en, this message translates to:
  /// **'It does not replace professional rescue. Call 112 and follow AFAD and the rescue teams on site.'**
  String get noticeDoesNotBody;

  /// No description provided for @noticeAccept.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get noticeAccept;

  /// No description provided for @siteTitle.
  ///
  /// In en, this message translates to:
  /// **'Rubble site'**
  String get siteTitle;

  /// No description provided for @siteHint.
  ///
  /// In en, this message translates to:
  /// **'Walk around the rubble and tap each corner.'**
  String get siteHint;

  /// No description provided for @siteSummary.
  ///
  /// In en, this message translates to:
  /// **'4 corners · {width} × {depth} m'**
  String siteSummary(String width, String depth);

  /// No description provided for @siteDone.
  ///
  /// In en, this message translates to:
  /// **'Outline done'**
  String get siteDone;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Ambient scan'**
  String get scanTitle;

  /// No description provided for @scanStand.
  ///
  /// In en, this message translates to:
  /// **'Stand 10 m away from the rubble.'**
  String get scanStand;

  /// No description provided for @scanBody.
  ///
  /// In en, this message translates to:
  /// **'Phones on the surface — rescuers, bystanders — are listed now and will not be suggested as targets.'**
  String get scanBody;

  /// No description provided for @scanFound.
  ///
  /// In en, this message translates to:
  /// **'Surface phones found'**
  String get scanFound;

  /// No description provided for @scanContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get scanContinue;

  /// No description provided for @secondsLeft.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds left'**
  String secondsLeft(int seconds);

  /// No description provided for @targetTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the target'**
  String get targetTitle;

  /// No description provided for @targetHint.
  ///
  /// In en, this message translates to:
  /// **'Hold a rescuer\'s phone next to yours to exclude it.'**
  String get targetHint;

  /// No description provided for @targetSamsung.
  ///
  /// In en, this message translates to:
  /// **'Samsung phone'**
  String get targetSamsung;

  /// No description provided for @targetUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown device'**
  String get targetUnknown;

  /// No description provided for @targetReasonLikely.
  ///
  /// In en, this message translates to:
  /// **'Not moving · weak signal · not seen on the surface'**
  String get targetReasonLikely;

  /// No description provided for @targetReasonMedium.
  ///
  /// In en, this message translates to:
  /// **'Not moving · medium signal'**
  String get targetReasonMedium;

  /// No description provided for @targetReasonMoving.
  ///
  /// In en, this message translates to:
  /// **'Moving — probably on the surface'**
  String get targetReasonMoving;

  /// No description provided for @targetTrack.
  ///
  /// In en, this message translates to:
  /// **'Track this phone'**
  String get targetTrack;

  /// No description provided for @measureTitle.
  ///
  /// In en, this message translates to:
  /// **'Point 3 of 5'**
  String get measureTitle;

  /// No description provided for @measureHold.
  ///
  /// In en, this message translates to:
  /// **'Hold the phone still at this point.'**
  String get measureHold;

  /// No description provided for @measureHeard.
  ///
  /// In en, this message translates to:
  /// **'Signal heard: −71 dBm.'**
  String get measureHeard;

  /// No description provided for @measureStill.
  ///
  /// In en, this message translates to:
  /// **'The phone is still.'**
  String get measureStill;

  /// No description provided for @measureShowMap.
  ///
  /// In en, this message translates to:
  /// **'Show the map'**
  String get measureShowMap;

  /// No description provided for @measureDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard this point'**
  String get measureDiscard;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Probability map'**
  String get mapTitle;

  /// No description provided for @mapRotation.
  ///
  /// In en, this message translates to:
  /// **'Its Bluetooth identity changes in about 2 min. Stay near the rubble.'**
  String get mapRotation;

  /// No description provided for @mapMostLikely.
  ///
  /// In en, this message translates to:
  /// **'Most likely area · 50 %'**
  String get mapMostLikely;

  /// No description provided for @mapRegion90.
  ///
  /// In en, this message translates to:
  /// **'90 %'**
  String get mapRegion90;

  /// No description provided for @mapHeard.
  ///
  /// In en, this message translates to:
  /// **'signal heard'**
  String get mapHeard;

  /// No description provided for @mapNoSignal.
  ///
  /// In en, this message translates to:
  /// **'no signal'**
  String get mapNoSignal;

  /// No description provided for @mapNext.
  ///
  /// In en, this message translates to:
  /// **'suggested next point'**
  String get mapNext;

  /// No description provided for @mapMeasure.
  ///
  /// In en, this message translates to:
  /// **'Measure here'**
  String get mapMeasure;

  /// No description provided for @victimSending.
  ///
  /// In en, this message translates to:
  /// **'Your phone is sending a help signal.'**
  String get victimSending;

  /// No description provided for @victimCalm.
  ///
  /// In en, this message translates to:
  /// **'Stay calm. Save your battery.'**
  String get victimCalm;

  /// No description provided for @victimTap.
  ///
  /// In en, this message translates to:
  /// **'When you hear rescuers, tap the screen 3 times.'**
  String get victimTap;

  /// No description provided for @victimBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get victimBattery;

  /// No description provided for @victimSos.
  ///
  /// In en, this message translates to:
  /// **'Play SOS sound'**
  String get victimSos;

  /// No description provided for @practiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice search'**
  String get practiceTitle;

  /// No description provided for @lastSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Last search'**
  String get lastSearchTitle;

  /// No description provided for @lastPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Last practice search'**
  String get lastPracticeTitle;

  /// Home card for the newest open session.
  ///
  /// In en, this message translates to:
  /// **'{title} · {count, plural, =0{no point measured yet} =1{1 point measured} other{{count} points measured}} · started {time}'**
  String lastSearchBody(String title, int count, String time);

  /// No description provided for @lastSearchContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue the search'**
  String get lastSearchContinue;

  /// No description provided for @lastSearchFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish this search'**
  String get lastSearchFinish;
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
