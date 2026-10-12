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

  /// No description provided for @newSiteTitle.
  ///
  /// In en, this message translates to:
  /// **'New search'**
  String get newSiteTitle;

  /// No description provided for @newSitePreparing.
  ///
  /// In en, this message translates to:
  /// **'This step is being prepared. Here you will draw the outline of the rubble site.'**
  String get newSitePreparing;

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
