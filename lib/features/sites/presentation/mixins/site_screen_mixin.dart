import 'package:beneathsos_app/core/formatting/measures.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:rubble_core/rubble_core.dart';

/// One step of the rescuer flow on the overview; [opensDrawing] when tapping it draws the outline.
typedef SiteStep = ({
  String label,
  String status,
  bool done,
  bool opensDrawing,
});

/// The steps of a search, from its projected state.
mixin SiteScreenMixin {
  /// Outline, surface phones, target, measured points. [state] is null while loading or when stored
  /// data cannot be read; only an [open] search can be drawn.
  List<SiteStep> stepsFor(
    AppLocalizations l10n,
    SessionState? state, {
    required bool open,
  }) {
    SiteStep comingLater(String label, {required bool done}) => (
      label: label,
      status: done ? l10n.siteStepDone : l10n.siteStepNext,
      done: done,
      opensDrawing: false,
    );
    final outline = state?.outline;
    final scale = state?.scale ?? 1;
    final measured = state?.measuredPoints.length ?? 0;
    return [
      (
        label: l10n.siteStepOutline,
        status: outline != null
            ? l10n.siteOutlineDone(
                squareMetresLabel(
                  l10n,
                  SquareMeters(outline.area.value * scale * scale),
                ),
              )
            : (open ? l10n.siteStepStart : l10n.siteStepNotDone),
        done: outline != null,
        opensDrawing: open && state != null,
      ),
      comingLater(
        l10n.siteStepAmbient,
        done: state?.blacklist.isNotEmpty ?? false,
      ),
      comingLater(
        l10n.siteStepTarget,
        done: state?.targets.isNotEmpty ?? false,
      ),
      (
        label: l10n.siteStepMeasure,
        status: measured > 0
            ? l10n.siteMeasuredCount(measured)
            : l10n.siteStepNext,
        done: measured > 0,
        opensDrawing: false,
      ),
    ];
  }
}
