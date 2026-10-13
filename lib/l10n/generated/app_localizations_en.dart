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
  String get victimSending => 'Your phone is calling out to rescuers.';

  @override
  String get victimCalm =>
      'Stay calm. Keep this screen open — it stays dark to save battery.';

  @override
  String get victimTap =>
      'Touch the screen now and then: rescuers can see that the phone was touched or moved recently.';

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

  @override
  String lastSearchUnreadable(String title, String time) {
    return '$title · some of its data could not be read · started $time';
  }

  @override
  String get finishConfirmTitle => 'Finish this search?';

  @override
  String get finishConfirmBody =>
      'You will not be able to continue it. Everything recorded stays saved.';

  @override
  String get finishConfirmYes => 'Finish';

  @override
  String get finishConfirmNo => 'Keep it open';

  @override
  String get sitesTitle => 'Searches';

  @override
  String get sitesNew => 'New search';

  @override
  String get sitesEmpty => 'No searches yet.';

  @override
  String get sitesPractice => 'Practice with sample data';

  @override
  String get sitesLoadFailed =>
      'The searches could not be loaded. Nothing was deleted.';

  @override
  String searchTileBody(int count, String started) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points measured',
      one: '1 point measured',
      zero: 'no point measured yet',
    );
    return '$_temp0 · started $started';
  }

  @override
  String searchTileUnreadable(String started) {
    return 'some of its data could not be read · started $started';
  }

  @override
  String get searchFinished => 'Finished';

  @override
  String get newSiteTitle => 'New search';

  @override
  String get newSiteLabel => 'Name of the site';

  @override
  String get newSiteHint => 'e.g. Atatürk Cad. 12, Antakya';

  @override
  String get newSiteEmpty => 'Enter a name so you can find this search later.';

  @override
  String get newSiteTooLong => 'Use at most 80 characters.';

  @override
  String get newSiteCreate => 'Create search';

  @override
  String get searchTitle => 'Search';

  @override
  String siteStarted(String started) {
    return 'Started $started';
  }

  @override
  String get siteStepOutline => 'Draw the rubble outline';

  @override
  String get siteStepAmbient => 'Find the phones on the surface';

  @override
  String get siteStepTarget => 'Choose the phone to search for';

  @override
  String get siteStepMeasure => 'Measure at points around the rubble';

  @override
  String get siteStepDone => 'Done';

  @override
  String get siteStepNext => 'Coming in the next update';

  @override
  String siteMeasuredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points measured',
      one: '1 point measured',
    );
    return '$_temp0';
  }

  @override
  String get siteFinished => 'This search is finished. Its data stays saved.';

  @override
  String get siteUnreadable =>
      'Some of this search\'s data could not be read. Nothing was deleted.';

  @override
  String get siteNotFound => 'This search could not be opened.';

  @override
  String get siteBackToList => 'Back to searches';

  @override
  String get newSiteFailed =>
      'The search could not be saved. Try again in a moment.';

  @override
  String get finishFailed =>
      'The search could not be finished. Try again in a moment.';

  @override
  String get drawTitle => 'Rubble outline';

  @override
  String get drawHint =>
      'Tap each corner of the rubble. Drag a corner to move it.';

  @override
  String get drawUndo => 'Undo';

  @override
  String get drawClear => 'Clear';

  @override
  String drawSummary(int corners, String perimeter, String area) {
    return '$corners corners · perimeter $perimeter · area $area';
  }

  @override
  String get drawTooFew => 'Tap at least 3 corners.';

  @override
  String get drawTooClose =>
      'Two corners are almost on top of each other. Move one apart.';

  @override
  String get drawCrossing => 'Two sides cross. Drag a corner so they do not.';

  @override
  String get drawNoArea => 'The outline has no area. Spread the corners out.';

  @override
  String get drawBadCorner =>
      'A corner could not be placed. Undo the last change.';

  @override
  String get drawNotSaved =>
      'The outline could not be saved. Try again in a moment.';

  @override
  String get drawLoadFailed =>
      'This outline could not be opened. Nothing was deleted.';

  @override
  String get clearConfirmTitle => 'Clear the outline?';

  @override
  String get clearConfirmBody => 'All corners are removed. You can undo it.';

  @override
  String get clearConfirmYes => 'Clear';

  @override
  String get clearConfirmNo => 'Keep it';

  @override
  String lengthMetres(String value) {
    return '$value m';
  }

  @override
  String areaSquareMetres(String value) {
    return '$value m²';
  }

  @override
  String get scaleTitle => 'Real size';

  @override
  String get scaleQuestion => 'How long is the highlighted side really?';

  @override
  String get scalePickHint => 'Tap another side to measure that one instead.';

  @override
  String scaleNow(String length) {
    return 'Now shown as $length';
  }

  @override
  String get scaleLabel => 'Real length in metres';

  @override
  String get scaleHowTitle => 'How did you measure it?';

  @override
  String get scaleTape => 'Tape measure';

  @override
  String get scaleSteps => 'Paced steps';

  @override
  String get scaleEstimate => 'Estimate';

  @override
  String get scaleSave => 'Save the size';

  @override
  String get scaleSkip => 'Skip';

  @override
  String get scaleNotANumber => 'Enter a number, for example 18.5.';

  @override
  String get scaleOutOfRange => 'Use a length between 0.5 and 500 m.';

  @override
  String get scaleNotSaved =>
      'The size could not be saved. Try again in a moment.';

  @override
  String siteOutlineDone(String area) {
    return 'Done · $area';
  }

  @override
  String get siteStepStart => 'Tap to start';

  @override
  String get siteStepNotDone => 'Not done';

  @override
  String get leaveDrawTitle => 'Leave without saving?';

  @override
  String get leaveDrawBody =>
      'The corners drawn since the last save will be lost.';

  @override
  String get leaveDrawStay => 'Keep drawing';

  @override
  String get leaveDrawLeave => 'Leave';

  @override
  String get scaleConfirmTitle => 'Is this right?';

  @override
  String scaleConfirmBody(String factor, String real) {
    return 'Every length becomes $factor times what you drew: this side would be $real. Check the number.';
  }

  @override
  String get scaleConfirmFix => 'Correct it';

  @override
  String get scaleConfirmSave => 'Save anyway';

  @override
  String get unitMetres => 'm';

  @override
  String get scaleNoOutline => 'Draw the outline first.';

  @override
  String get ambientTitle => 'Surface phones';

  @override
  String ambientHeard(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count phones heard so far',
      one: '1 phone heard so far',
      zero: 'No phone heard yet',
    );
    return '$_temp0';
  }

  @override
  String ambientDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count surface phones set aside. They will not be suggested.',
      one: '1 surface phone set aside. It will not be suggested.',
      zero: 'No phone close by: nothing was set aside.',
    );
    return '$_temp0';
  }

  @override
  String get ambientNotSaved => 'The scan could not be saved. Scan again.';

  @override
  String get ambientAgain => 'Scan again';

  @override
  String get ambientChoose => 'Choose the phone';

  @override
  String get ambientBack => 'Back to the search';

  @override
  String get targetsHintExclude =>
      'Hold a team phone next to yours: the card that turns very strong is that phone — exclude it.';

  @override
  String get targetsNoSurfaceScan =>
      'No surface scan yet: rescuers\' phones may be listed. Tap to scan first.';

  @override
  String get targetsNone => 'No phones heard yet. Keep this screen open.';

  @override
  String get reasonNotMoving => 'Not moving';

  @override
  String get reasonWeak => 'weak signal';

  @override
  String get reasonMedium => 'medium signal';

  @override
  String get reasonNotOnSurface => 'not strong in the surface scan';

  @override
  String get reasonVeryStrong =>
      'Very strong signal — if this is a team phone, exclude it';

  @override
  String targetSignal(String value) {
    return 'Signal $value dBm';
  }

  @override
  String get targetExclude => 'Exclude — it is on the surface';

  @override
  String get targetNotSaved => 'Could not be saved. Try again in a moment.';

  @override
  String get kindFindMy => 'Apple · Find My';

  @override
  String get kindApple => 'Apple device';

  @override
  String get kindWindows => 'Windows device';

  @override
  String get kindGoogle => 'Android device (Google)';

  @override
  String get kindOther => 'Bluetooth device';

  @override
  String siteAmbientDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Done · $count phones set aside',
      one: 'Done · 1 phone set aside',
      zero: 'Done · nothing set aside',
    );
    return '$_temp0';
  }

  @override
  String siteTargetDone(String label) {
    return 'Done · $label';
  }

  @override
  String get reasonChanging => 'Signal changing — it may be moving';

  @override
  String get reasonFewReadings => 'Heard only a few times so far';

  @override
  String targetsSurfaceScanOld(int minutes) {
    return 'Surface scan $minutes min ago: phones change their Bluetooth identity about every 15 min. Tap to scan again.';
  }

  @override
  String excludeDone(String label) {
    return 'Set aside: $label.';
  }

  @override
  String setAsideTitle(int count) {
    return 'Set aside ($count)';
  }

  @override
  String get putBack => 'Put back';

  @override
  String get setAsideNotHeard => 'Not heard now';

  @override
  String get sortAgain => 'Sort again';

  @override
  String get scanFailed => 'Scanning stopped. Tap to try again.';

  @override
  String get pointTitle => 'Measure';

  @override
  String get pointChoose =>
      'Stand at a spot around the rubble and tap where you are on the map.';

  @override
  String pointSummary(int count, int heard) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points measured',
      one: '1 point measured',
      zero: 'No point measured yet',
    );
    return '$_temp0 · $heard with a signal';
  }

  @override
  String get pointMoving =>
      'Moving — the count waits until the phone is still.';

  @override
  String pointHeard(String label) {
    return '$label: signal heard';
  }

  @override
  String pointNotYet(String label) {
    return '$label: not heard yet';
  }

  @override
  String pointSavedHeard(String value) {
    return 'Point saved: signal heard ($value dBm).';
  }

  @override
  String get pointSavedNotHeard =>
      'Point saved: not heard — that is information too.';

  @override
  String get pointNotSaved => 'The point could not be saved. Measure again.';

  @override
  String get pointNeedsOutline => 'Draw the rubble outline first.';

  @override
  String get pointNeedsTarget => 'Choose the phone to search for first.';

  @override
  String relinkQuestion(String label, int seconds) {
    return '$label may have changed its Bluetooth identity: a new one appeared $seconds s after it went silent, with a similar signal. Is it the same phone?';
  }

  @override
  String get relinkYes => 'Yes, the same phone';

  @override
  String get mapLegend =>
      'Filled diamond: signal heard · Hollow diamond: not heard · Orange circle: measuring now';

  @override
  String get pointRadioSilent =>
      'No Bluetooth device was heard at all — scanning was not working. The point was not stored; measure again.';

  @override
  String get pointStart => 'Measure here';

  @override
  String get pointMoveHint => 'Tap the map again to move the point.';

  @override
  String get pointSaving => 'Saving the point…';

  @override
  String get relinkNo => 'No, not this one';

  @override
  String get probTitle => 'Probability map';

  @override
  String probAreas(String area50, String area90) {
    return 'Most likely area: $area50 (50 %) · $area90 (90 %)';
  }

  @override
  String probLowInfo(int count) {
    return 'Not enough information: fewer than $count places with a signal. Measure more points around the rubble.';
  }

  @override
  String get probNeedsPoint =>
      'Measure at least one point around the rubble first.';

  @override
  String get probCalculating => 'Calculating the map…';

  @override
  String get probFailed =>
      'The map could not be calculated. Nothing was deleted.';

  @override
  String get probMeasureNext => 'Measure next point';

  @override
  String get probLegend =>
      'Diamonds: measured points (number = signal in dBm, warmer = stronger, hollow = not heard) · + and dashed circle: most likely spot · Ring: suggested next point · Strong colour: 50 % · Faint: 90 %';

  @override
  String get probRule =>
      'This is an area where the phone most likely is — never an exact spot.';

  @override
  String get siteOpenMap => 'Open the probability map';

  @override
  String probOnRubble(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points on the rubble are not used',
      one: '1 point on the rubble is not used',
    );
    return '$_temp0: the map works from points around it.';
  }

  @override
  String get victimStarting => 'Starting the help signal…';

  @override
  String victimSignalName(String name) {
    return 'Signal name: $name';
  }

  @override
  String victimBatteryValue(int percent) {
    return 'Battery: $percent %';
  }

  @override
  String get victimNeedsPermission =>
      'Allow Bluetooth so rescuers can find this phone.';

  @override
  String get victimAllow => 'Allow Bluetooth';

  @override
  String get victimNeedsSettings =>
      'Bluetooth access is off for BeneathSOS. Turn it on in Settings.';

  @override
  String get victimOpenSettings => 'Open Settings';

  @override
  String get victimBluetoothOff =>
      'Turn on Bluetooth so rescuers can find this phone.';

  @override
  String get victimUnsupported =>
      'This phone cannot send a Bluetooth help signal. Use the SOS sound.';

  @override
  String get victimFailed => 'The help signal stopped.';

  @override
  String get victimRetry => 'Try again';

  @override
  String get victim112 => 'If you have mobile signal, call 112.';

  @override
  String get victimSosStop => 'Stop the SOS sound';

  @override
  String get victimStopTitle => 'Stop calling out?';

  @override
  String get victimStopBody =>
      'Rescuers will no longer find this phone by its signal.';

  @override
  String get victimKeep => 'Keep calling out';

  @override
  String get victimStop => 'Stop';

  @override
  String get kindTrapped => 'BeneathSOS: “I am trapped”';

  @override
  String get reasonTrapped => 'This phone says it is trapped';

  @override
  String reasonBattery(int percent) {
    return 'battery $percent %';
  }

  @override
  String reasonTouched(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'moved or touched $minutes min ago',
      one: 'moved or touched 1 min ago',
      zero: 'moved or touched in the last minute',
    );
    return '$_temp0';
  }

  @override
  String get reasonUntouched => 'not moved or touched for over 4 hours';

  @override
  String get exportTitle => 'Export this search';

  @override
  String get exportContents =>
      'Two files: the search as recorded (every step, point and reading, and this notice) and the raw signal readings. Phones that are not targets appear only as codes that cannot be traced back. You choose where the files go.';

  @override
  String get exportShare => 'Export and share';

  @override
  String get exportDone => 'Shared. The files hold this search as recorded.';

  @override
  String get exportFailed => 'Could not export. Nothing was changed.';

  @override
  String get siteExport => 'Export this search';

  @override
  String get victimSosHint => 'Turn the volume all the way up.';

  @override
  String get probRecordFound => 'Record where it was found';

  @override
  String get probTapFound =>
      'Tap the spot on the map where the phone was found.';

  @override
  String get probFound50 => 'Found inside the 50 % area.';

  @override
  String get probFound90 => 'Found inside the 90 % area.';

  @override
  String probFoundOutside(String distance) {
    return 'Found outside the 90 % area, $distance from it.';
  }

  @override
  String get probRecordFailed =>
      'Could not save where it was found. Try again.';

  @override
  String get probConfirmFoundTitle => 'Record the phone as found here?';

  @override
  String get probConfirmFoundBody =>
      'Everyone on this search will see it as found here. Record it only once the phone is in hand.';

  @override
  String get probConfirmFoundYes => 'Record';

  @override
  String get probConfirmFoundNo => 'Not here';

  @override
  String get probCancel => 'Cancel';

  @override
  String probSpot(String radius, String fromEdge) {
    return 'Most likely spot: inside the dashed circle (half the chance; radius $radius), $fromEdge in from the nearest edge of the rubble.';
  }

  @override
  String get probBunched =>
      'Your points are close together: measure all around the rubble, at least 3 m apart.';

  @override
  String get circlesToggle => 'Signal circles (rough guide)';

  @override
  String circlesMeet(String distance) {
    return 'Circles meet about $distance from the nearest measured point. Rough guide: each circle assumes the signal crossed rubble all the way.';
  }

  @override
  String get circlesOne =>
      'Measure one more point with a signal to see where the circles meet.';

  @override
  String get mapNextLabel => 'Measure next';

  @override
  String get searchDelete => 'Delete';

  @override
  String searchDeleteTitle(String title) {
    return 'Delete “$title”?';
  }

  @override
  String get searchDeleteBody =>
      'Its outline, points and readings are deleted from this phone. This cannot be undone — export it first if you need it.';

  @override
  String get searchDeleteKeep => 'Keep it';

  @override
  String get searchDeleteConfirm => 'Delete';

  @override
  String get sitesDeleteFailed => 'Could not delete. Nothing was changed.';

  @override
  String get depthTitle => 'Rubble height and level';

  @override
  String get depthIntro =>
      'The signal cannot tell how deep the phone is. Tell the app what you know — the map and the signal circles use it.';

  @override
  String get depthHeight => 'Height of the rubble (m)';

  @override
  String depthFloors(int floors, int metres) {
    String _temp0 = intl.Intl.pluralLogic(
      floors,
      locale: localeName,
      other: '$floors floors ≈ $metres m',
      one: '1 floor ≈ $metres m',
    );
    return '$_temp0';
  }

  @override
  String get depthLevel => 'Where was the person most likely?';

  @override
  String get depthSave => 'Save';

  @override
  String get depthEnterNumber => 'Enter the height in metres, for example 6.';

  @override
  String get depthRange => 'Use a height between 0.5 and 100 m.';

  @override
  String get depthSaveFailed => 'Could not save. Nothing was changed.';

  @override
  String get levelUpper => 'Upper part';

  @override
  String get levelMiddle => 'Middle';

  @override
  String get levelBottom => 'Ground floor (bottom)';

  @override
  String get levelBasement => 'Basement';

  @override
  String get levelUnknown => 'Don\'t know';

  @override
  String get siteStepDepth => 'Rubble height and level';

  @override
  String siteDepthDone(String height, String level) {
    return '$height · $level';
  }

  @override
  String probDepth(String height, String level) {
    return 'Depth: $height of rubble · $level.';
  }

  @override
  String get probDepthUnset =>
      'Depth not given: the map assumes 4 m of rubble. Set it on the overview.';

  @override
  String baroLine(String where) {
    return 'Its barometer: $where (± 8 m).';
  }

  @override
  String get baroAbove => 'above you';

  @override
  String get baroLevel => 'about your level';

  @override
  String get baroBelow => '1–3 floors below you';

  @override
  String get baroDeep => 'more than 3 floors below you';
}
