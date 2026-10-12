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

  /// Home card when a stored event of the search no longer decodes.
  ///
  /// In en, this message translates to:
  /// **'{title} · some of its data could not be read · started {time}'**
  String lastSearchUnreadable(String title, String time);

  /// No description provided for @finishConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish this search?'**
  String get finishConfirmTitle;

  /// No description provided for @finishConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You will not be able to continue it. Everything recorded stays saved.'**
  String get finishConfirmBody;

  /// No description provided for @finishConfirmYes.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finishConfirmYes;

  /// No description provided for @finishConfirmNo.
  ///
  /// In en, this message translates to:
  /// **'Keep it open'**
  String get finishConfirmNo;

  /// No description provided for @sitesTitle.
  ///
  /// In en, this message translates to:
  /// **'Searches'**
  String get sitesTitle;

  /// No description provided for @sitesNew.
  ///
  /// In en, this message translates to:
  /// **'New search'**
  String get sitesNew;

  /// No description provided for @sitesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No searches yet.'**
  String get sitesEmpty;

  /// No description provided for @sitesPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice with sample data'**
  String get sitesPractice;

  /// No description provided for @sitesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'The searches could not be loaded. Nothing was deleted.'**
  String get sitesLoadFailed;

  /// No description provided for @searchTileBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no point measured yet} =1{1 point measured} other{{count} points measured}} · started {started}'**
  String searchTileBody(int count, String started);

  /// No description provided for @searchTileUnreadable.
  ///
  /// In en, this message translates to:
  /// **'some of its data could not be read · started {started}'**
  String searchTileUnreadable(String started);

  /// No description provided for @searchFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get searchFinished;

  /// No description provided for @newSiteTitle.
  ///
  /// In en, this message translates to:
  /// **'New search'**
  String get newSiteTitle;

  /// No description provided for @newSiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Name of the site'**
  String get newSiteLabel;

  /// No description provided for @newSiteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Atatürk Cad. 12, Antakya'**
  String get newSiteHint;

  /// No description provided for @newSiteEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter a name so you can find this search later.'**
  String get newSiteEmpty;

  /// No description provided for @newSiteTooLong.
  ///
  /// In en, this message translates to:
  /// **'Use at most 80 characters.'**
  String get newSiteTooLong;

  /// No description provided for @newSiteCreate.
  ///
  /// In en, this message translates to:
  /// **'Create search'**
  String get newSiteCreate;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @siteStarted.
  ///
  /// In en, this message translates to:
  /// **'Started {started}'**
  String siteStarted(String started);

  /// No description provided for @siteStepOutline.
  ///
  /// In en, this message translates to:
  /// **'Draw the rubble outline'**
  String get siteStepOutline;

  /// No description provided for @siteStepAmbient.
  ///
  /// In en, this message translates to:
  /// **'Find the phones on the surface'**
  String get siteStepAmbient;

  /// No description provided for @siteStepTarget.
  ///
  /// In en, this message translates to:
  /// **'Choose the phone to search for'**
  String get siteStepTarget;

  /// No description provided for @siteStepMeasure.
  ///
  /// In en, this message translates to:
  /// **'Measure at points around the rubble'**
  String get siteStepMeasure;

  /// No description provided for @siteStepDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get siteStepDone;

  /// No description provided for @siteStepNext.
  ///
  /// In en, this message translates to:
  /// **'Coming in the next update'**
  String get siteStepNext;

  /// No description provided for @siteMeasuredCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 point measured} other{{count} points measured}}'**
  String siteMeasuredCount(int count);

  /// No description provided for @siteFinished.
  ///
  /// In en, this message translates to:
  /// **'This search is finished. Its data stays saved.'**
  String get siteFinished;

  /// No description provided for @siteUnreadable.
  ///
  /// In en, this message translates to:
  /// **'Some of this search\'s data could not be read. Nothing was deleted.'**
  String get siteUnreadable;

  /// No description provided for @siteNotFound.
  ///
  /// In en, this message translates to:
  /// **'This search could not be opened.'**
  String get siteNotFound;

  /// No description provided for @siteBackToList.
  ///
  /// In en, this message translates to:
  /// **'Back to searches'**
  String get siteBackToList;

  /// No description provided for @newSiteFailed.
  ///
  /// In en, this message translates to:
  /// **'The search could not be saved. Try again in a moment.'**
  String get newSiteFailed;

  /// No description provided for @finishFailed.
  ///
  /// In en, this message translates to:
  /// **'The search could not be finished. Try again in a moment.'**
  String get finishFailed;

  /// No description provided for @drawTitle.
  ///
  /// In en, this message translates to:
  /// **'Rubble outline'**
  String get drawTitle;

  /// No description provided for @drawHint.
  ///
  /// In en, this message translates to:
  /// **'Tap each corner of the rubble. Drag a corner to move it.'**
  String get drawHint;

  /// No description provided for @drawUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get drawUndo;

  /// No description provided for @drawClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get drawClear;

  /// No description provided for @drawSummary.
  ///
  /// In en, this message translates to:
  /// **'{corners} corners · perimeter {perimeter} · area {area}'**
  String drawSummary(int corners, String perimeter, String area);

  /// No description provided for @drawTooFew.
  ///
  /// In en, this message translates to:
  /// **'Tap at least 3 corners.'**
  String get drawTooFew;

  /// No description provided for @drawTooClose.
  ///
  /// In en, this message translates to:
  /// **'Two corners are almost on top of each other. Move one apart.'**
  String get drawTooClose;

  /// No description provided for @drawCrossing.
  ///
  /// In en, this message translates to:
  /// **'Two sides cross. Drag a corner so they do not.'**
  String get drawCrossing;

  /// No description provided for @drawNoArea.
  ///
  /// In en, this message translates to:
  /// **'The outline has no area. Spread the corners out.'**
  String get drawNoArea;

  /// No description provided for @drawBadCorner.
  ///
  /// In en, this message translates to:
  /// **'A corner could not be placed. Undo the last change.'**
  String get drawBadCorner;

  /// No description provided for @drawNotSaved.
  ///
  /// In en, this message translates to:
  /// **'The outline could not be saved. Try again in a moment.'**
  String get drawNotSaved;

  /// No description provided for @drawLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'This outline could not be opened. Nothing was deleted.'**
  String get drawLoadFailed;

  /// No description provided for @clearConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear the outline?'**
  String get clearConfirmTitle;

  /// No description provided for @clearConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'All corners are removed. You can undo it.'**
  String get clearConfirmBody;

  /// No description provided for @clearConfirmYes.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearConfirmYes;

  /// No description provided for @clearConfirmNo.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get clearConfirmNo;

  /// No description provided for @lengthMetres.
  ///
  /// In en, this message translates to:
  /// **'{value} m'**
  String lengthMetres(String value);

  /// No description provided for @areaSquareMetres.
  ///
  /// In en, this message translates to:
  /// **'{value} m²'**
  String areaSquareMetres(String value);

  /// No description provided for @scaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Real size'**
  String get scaleTitle;

  /// No description provided for @scaleQuestion.
  ///
  /// In en, this message translates to:
  /// **'How long is the highlighted side really?'**
  String get scaleQuestion;

  /// No description provided for @scalePickHint.
  ///
  /// In en, this message translates to:
  /// **'Tap another side to measure that one instead.'**
  String get scalePickHint;

  /// No description provided for @scaleNow.
  ///
  /// In en, this message translates to:
  /// **'Now shown as {length}'**
  String scaleNow(String length);

  /// No description provided for @scaleLabel.
  ///
  /// In en, this message translates to:
  /// **'Real length in metres'**
  String get scaleLabel;

  /// No description provided for @scaleHowTitle.
  ///
  /// In en, this message translates to:
  /// **'How did you measure it?'**
  String get scaleHowTitle;

  /// No description provided for @scaleTape.
  ///
  /// In en, this message translates to:
  /// **'Tape measure'**
  String get scaleTape;

  /// No description provided for @scaleSteps.
  ///
  /// In en, this message translates to:
  /// **'Paced steps'**
  String get scaleSteps;

  /// No description provided for @scaleEstimate.
  ///
  /// In en, this message translates to:
  /// **'Estimate'**
  String get scaleEstimate;

  /// No description provided for @scaleSave.
  ///
  /// In en, this message translates to:
  /// **'Save the size'**
  String get scaleSave;

  /// No description provided for @scaleSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get scaleSkip;

  /// No description provided for @scaleNotANumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number, for example 18.5.'**
  String get scaleNotANumber;

  /// No description provided for @scaleOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'Use a length between 0.5 and 500 m.'**
  String get scaleOutOfRange;

  /// No description provided for @scaleNotSaved.
  ///
  /// In en, this message translates to:
  /// **'The size could not be saved. Try again in a moment.'**
  String get scaleNotSaved;

  /// No description provided for @siteOutlineDone.
  ///
  /// In en, this message translates to:
  /// **'Done · {area}'**
  String siteOutlineDone(String area);

  /// No description provided for @siteStepStart.
  ///
  /// In en, this message translates to:
  /// **'Tap to start'**
  String get siteStepStart;

  /// No description provided for @siteStepNotDone.
  ///
  /// In en, this message translates to:
  /// **'Not done'**
  String get siteStepNotDone;

  /// No description provided for @leaveDrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave without saving?'**
  String get leaveDrawTitle;

  /// No description provided for @leaveDrawBody.
  ///
  /// In en, this message translates to:
  /// **'The corners drawn since the last save will be lost.'**
  String get leaveDrawBody;

  /// No description provided for @leaveDrawStay.
  ///
  /// In en, this message translates to:
  /// **'Keep drawing'**
  String get leaveDrawStay;

  /// No description provided for @leaveDrawLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leaveDrawLeave;

  /// No description provided for @scaleConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Is this right?'**
  String get scaleConfirmTitle;

  /// No description provided for @scaleConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Every length becomes {factor} times what you drew: this side would be {real}. Check the number.'**
  String scaleConfirmBody(String factor, String real);

  /// No description provided for @scaleConfirmFix.
  ///
  /// In en, this message translates to:
  /// **'Correct it'**
  String get scaleConfirmFix;

  /// No description provided for @scaleConfirmSave.
  ///
  /// In en, this message translates to:
  /// **'Save anyway'**
  String get scaleConfirmSave;

  /// No description provided for @unitMetres.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get unitMetres;

  /// No description provided for @scaleNoOutline.
  ///
  /// In en, this message translates to:
  /// **'Draw the outline first.'**
  String get scaleNoOutline;

  /// No description provided for @ambientTitle.
  ///
  /// In en, this message translates to:
  /// **'Surface phones'**
  String get ambientTitle;

  /// No description provided for @ambientHeard.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No phone heard yet} =1{1 phone heard so far} other{{count} phones heard so far}}'**
  String ambientHeard(int count);

  /// No description provided for @ambientDone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No phone close by: nothing was set aside.} =1{1 surface phone set aside. It will not be suggested.} other{{count} surface phones set aside. They will not be suggested.}}'**
  String ambientDone(int count);

  /// No description provided for @ambientNotSaved.
  ///
  /// In en, this message translates to:
  /// **'The scan could not be saved. Scan again.'**
  String get ambientNotSaved;

  /// No description provided for @ambientAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get ambientAgain;

  /// No description provided for @ambientChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose the phone'**
  String get ambientChoose;

  /// No description provided for @ambientBack.
  ///
  /// In en, this message translates to:
  /// **'Back to the search'**
  String get ambientBack;

  /// No description provided for @targetsHintExclude.
  ///
  /// In en, this message translates to:
  /// **'Hold a team phone next to yours: the card that turns very strong is that phone — exclude it.'**
  String get targetsHintExclude;

  /// No description provided for @targetsNoSurfaceScan.
  ///
  /// In en, this message translates to:
  /// **'No surface scan yet: rescuers\' phones may be listed. Tap to scan first.'**
  String get targetsNoSurfaceScan;

  /// No description provided for @targetsNone.
  ///
  /// In en, this message translates to:
  /// **'No phones heard yet. Keep this screen open.'**
  String get targetsNone;

  /// No description provided for @reasonNotMoving.
  ///
  /// In en, this message translates to:
  /// **'Not moving'**
  String get reasonNotMoving;

  /// No description provided for @reasonWeak.
  ///
  /// In en, this message translates to:
  /// **'weak signal'**
  String get reasonWeak;

  /// No description provided for @reasonMedium.
  ///
  /// In en, this message translates to:
  /// **'medium signal'**
  String get reasonMedium;

  /// No description provided for @reasonNotOnSurface.
  ///
  /// In en, this message translates to:
  /// **'not strong in the surface scan'**
  String get reasonNotOnSurface;

  /// No description provided for @reasonVeryStrong.
  ///
  /// In en, this message translates to:
  /// **'Very strong signal — if this is a team phone, exclude it'**
  String get reasonVeryStrong;

  /// No description provided for @targetSignal.
  ///
  /// In en, this message translates to:
  /// **'Signal {value} dBm'**
  String targetSignal(String value);

  /// No description provided for @targetExclude.
  ///
  /// In en, this message translates to:
  /// **'Exclude — it is on the surface'**
  String get targetExclude;

  /// No description provided for @targetNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Could not be saved. Try again in a moment.'**
  String get targetNotSaved;

  /// No description provided for @kindFindMy.
  ///
  /// In en, this message translates to:
  /// **'Apple · Find My'**
  String get kindFindMy;

  /// No description provided for @kindApple.
  ///
  /// In en, this message translates to:
  /// **'Apple device'**
  String get kindApple;

  /// No description provided for @kindWindows.
  ///
  /// In en, this message translates to:
  /// **'Windows device'**
  String get kindWindows;

  /// No description provided for @kindGoogle.
  ///
  /// In en, this message translates to:
  /// **'Android device (Google)'**
  String get kindGoogle;

  /// No description provided for @kindOther.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth device'**
  String get kindOther;

  /// No description provided for @siteAmbientDone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Done · nothing set aside} =1{Done · 1 phone set aside} other{Done · {count} phones set aside}}'**
  String siteAmbientDone(int count);

  /// No description provided for @siteTargetDone.
  ///
  /// In en, this message translates to:
  /// **'Done · {label}'**
  String siteTargetDone(String label);

  /// No description provided for @reasonChanging.
  ///
  /// In en, this message translates to:
  /// **'Signal changing — it may be moving'**
  String get reasonChanging;

  /// No description provided for @reasonFewReadings.
  ///
  /// In en, this message translates to:
  /// **'Heard only a few times so far'**
  String get reasonFewReadings;

  /// No description provided for @targetsSurfaceScanOld.
  ///
  /// In en, this message translates to:
  /// **'Surface scan {minutes} min ago: phones change their Bluetooth identity about every 15 min. Tap to scan again.'**
  String targetsSurfaceScanOld(int minutes);

  /// No description provided for @excludeDone.
  ///
  /// In en, this message translates to:
  /// **'Set aside: {label}.'**
  String excludeDone(String label);

  /// No description provided for @setAsideTitle.
  ///
  /// In en, this message translates to:
  /// **'Set aside ({count})'**
  String setAsideTitle(int count);

  /// No description provided for @putBack.
  ///
  /// In en, this message translates to:
  /// **'Put back'**
  String get putBack;

  /// No description provided for @setAsideNotHeard.
  ///
  /// In en, this message translates to:
  /// **'Not heard now'**
  String get setAsideNotHeard;

  /// No description provided for @sortAgain.
  ///
  /// In en, this message translates to:
  /// **'Sort again'**
  String get sortAgain;

  /// No description provided for @scanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scanning stopped. Tap to try again.'**
  String get scanFailed;

  /// No description provided for @pointTitle.
  ///
  /// In en, this message translates to:
  /// **'Measure'**
  String get pointTitle;

  /// No description provided for @pointChoose.
  ///
  /// In en, this message translates to:
  /// **'Stand at a spot around the rubble and tap where you are on the map.'**
  String get pointChoose;

  /// No description provided for @pointSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No point measured yet} =1{1 point measured} other{{count} points measured}} · {heard} with a signal'**
  String pointSummary(int count, int heard);

  /// No description provided for @pointMoving.
  ///
  /// In en, this message translates to:
  /// **'Moving — the count waits until the phone is still.'**
  String get pointMoving;

  /// No description provided for @pointHeard.
  ///
  /// In en, this message translates to:
  /// **'{label}: signal heard'**
  String pointHeard(String label);

  /// No description provided for @pointNotYet.
  ///
  /// In en, this message translates to:
  /// **'{label}: not heard yet'**
  String pointNotYet(String label);

  /// No description provided for @pointSavedHeard.
  ///
  /// In en, this message translates to:
  /// **'Point saved: signal heard ({value} dBm).'**
  String pointSavedHeard(String value);

  /// No description provided for @pointSavedNotHeard.
  ///
  /// In en, this message translates to:
  /// **'Point saved: not heard — that is information too.'**
  String get pointSavedNotHeard;

  /// No description provided for @pointNotSaved.
  ///
  /// In en, this message translates to:
  /// **'The point could not be saved. Measure again.'**
  String get pointNotSaved;

  /// No description provided for @pointNeedsOutline.
  ///
  /// In en, this message translates to:
  /// **'Draw the rubble outline first.'**
  String get pointNeedsOutline;

  /// No description provided for @pointNeedsTarget.
  ///
  /// In en, this message translates to:
  /// **'Choose the phone to search for first.'**
  String get pointNeedsTarget;

  /// No description provided for @relinkQuestion.
  ///
  /// In en, this message translates to:
  /// **'{label} may have changed its Bluetooth identity: a new one appeared {seconds} s after it went silent, with a similar signal. Is it the same phone?'**
  String relinkQuestion(String label, int seconds);

  /// No description provided for @relinkYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, the same phone'**
  String get relinkYes;

  /// No description provided for @mapLegend.
  ///
  /// In en, this message translates to:
  /// **'Filled: signal heard · Ring: not heard · Orange: measuring now'**
  String get mapLegend;

  /// No description provided for @pointRadioSilent.
  ///
  /// In en, this message translates to:
  /// **'No Bluetooth device was heard at all — scanning was not working. The point was not stored; measure again.'**
  String get pointRadioSilent;

  /// No description provided for @pointStart.
  ///
  /// In en, this message translates to:
  /// **'Measure here'**
  String get pointStart;

  /// No description provided for @pointMoveHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the map again to move the point.'**
  String get pointMoveHint;

  /// No description provided for @pointSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving the point…'**
  String get pointSaving;

  /// No description provided for @relinkNo.
  ///
  /// In en, this message translates to:
  /// **'No, not this one'**
  String get relinkNo;

  /// No description provided for @probTitle.
  ///
  /// In en, this message translates to:
  /// **'Probability map'**
  String get probTitle;

  /// No description provided for @probAreas.
  ///
  /// In en, this message translates to:
  /// **'Most likely area: {area50} (50 %) · {area90} (90 %)'**
  String probAreas(String area50, String area90);

  /// No description provided for @probLowInfo.
  ///
  /// In en, this message translates to:
  /// **'Low information: fewer than 3 points with a signal. Measure more points around the rubble.'**
  String get probLowInfo;

  /// No description provided for @probNeedsPoint.
  ///
  /// In en, this message translates to:
  /// **'Measure at least one point first.'**
  String get probNeedsPoint;

  /// No description provided for @probCalculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating the map…'**
  String get probCalculating;

  /// No description provided for @probFailed.
  ///
  /// In en, this message translates to:
  /// **'The map could not be calculated. Nothing was deleted.'**
  String get probFailed;

  /// No description provided for @probMeasureNext.
  ///
  /// In en, this message translates to:
  /// **'Measure next point'**
  String get probMeasureNext;

  /// No description provided for @probLegend.
  ///
  /// In en, this message translates to:
  /// **'Dark: most likely 50 % · Light: 90 % · Orange ring: suggested next point'**
  String get probLegend;

  /// No description provided for @probRule.
  ///
  /// In en, this message translates to:
  /// **'This is an area where the phone most likely is — never an exact spot.'**
  String get probRule;

  /// No description provided for @siteOpenMap.
  ///
  /// In en, this message translates to:
  /// **'Open the probability map'**
  String get siteOpenMap;
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
