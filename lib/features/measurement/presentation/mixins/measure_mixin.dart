import 'package:beneathsos_app/features/measurement/domain/measurement_state.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:rubble_canvas/rubble_canvas.dart';
import 'package:rubble_core/rubble_core.dart';

/// Map points and words of the measuring screen.
mixin MeasureMixin {
  /// Measured points (heard when any target was heard there) and the point being measured.
  List<MapPoint> mapPoints(SessionState search, MeasurementState state) => [
    for (final point in search.measuredPoints)
      if (point.at case final at?)
        MapPoint(
          at: at,
          kind: point.readings.any((r) => r is SignalHeard)
              ? MapPointKind.heard
              : MapPointKind.notHeard,
        ),
    if (state
        case Measuring(:final at) ||
            SavingMeasurement(:final at) ||
            ChoosingPoint(pending: final at?))
      MapPoint(at: at, kind: MapPointKind.measuring),
  ];

  /// "3 points measured · 2 with a signal".
  String summary(AppLocalizations l10n, SessionState search) {
    final measured = search.measuredPoints;
    return l10n.pointSummary(
      measured.length,
      measured.where((p) => p.readings.any((r) => r is SignalHeard)).length,
    );
  }

  /// One line per target: heard so far, or not yet.
  List<String> targetLines(
    AppLocalizations l10n,
    SessionState search,
    Measuring state,
  ) => [
    for (final MapEntry(:key, :value) in search.targets.entries)
      (state.heard[key] ?? 0) > 0
          ? l10n.pointHeard(value.label ?? value.peripheralKey)
          : l10n.pointNotYet(value.label ?? value.peripheralKey),
  ];

  /// What the last point recorded.
  String outcome(AppLocalizations l10n, MeasurementOutcome outcome) =>
      switch (outcome) {
        PointSaved(:final readings) => switch (readings
            .whereType<SignalHeard>()
            .firstOrNull) {
          final SignalHeard heard => l10n.pointSavedHeard(
            heard.median.value.round().toString().replaceFirst('-', '−'),
          ),
          null => l10n.pointSavedNotHeard,
        },
        PointNotSaved() => l10n.pointNotSaved,
        PointRadioSilent() => l10n.pointRadioSilent,
      };

  /// The relink question, naming the target.
  String relinkText(
    AppLocalizations l10n,
    SessionState search,
    RelinkSuggestion relink,
  ) {
    final target = search.targets[relink.target];
    return l10n.relinkQuestion(target?.label ?? relink.from, relink.gapSeconds);
  }
}
