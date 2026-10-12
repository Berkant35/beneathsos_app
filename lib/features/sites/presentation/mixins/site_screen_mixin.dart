import 'package:beneathsos_app/core/formatting/measures.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:rubble_core/rubble_core.dart';

/// Which screen a step of the overview opens.
enum SiteStepAction {
  /// Draw the rubble outline.
  draw,

  /// The surface scan.
  ambient,

  /// Choose the target.
  target,

  /// Measure at points.
  measure,
}

/// One step of the rescuer flow on the overview; [action] is the screen it opens, if any.
typedef SiteStep = ({
  String label,
  String status,
  bool done,
  SiteStepAction? action,
});

/// The steps of a search, from its projected state.
mixin SiteScreenMixin {
  /// Outline, surface phones, target, measured points. [state] is null while loading or when stored
  /// data cannot be read; only an [open] search can be changed.
  List<SiteStep> stepsFor(
    AppLocalizations l10n,
    SessionState? state, {
    required bool open,
  }) {
    final canOpen = open && state != null;
    String notDone() => open ? l10n.siteStepStart : l10n.siteStepNotDone;
    final outline = state?.outline;
    final scale = state?.scale ?? 1;
    final surface = state?.blacklist.length ?? 0;
    // A scan that set nothing aside is still done; a manual exclusion is not a scan.
    final scanned = state?.lastSurfaceScan != null;
    final target = state?.targets.values.firstOrNull;
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
            : notDone(),
        done: outline != null,
        action: canOpen ? SiteStepAction.draw : null,
      ),
      (
        label: l10n.siteStepAmbient,
        status: scanned ? l10n.siteAmbientDone(surface) : notDone(),
        done: scanned,
        action: canOpen ? SiteStepAction.ambient : null,
      ),
      (
        label: l10n.siteStepTarget,
        status: target != null
            ? l10n.siteTargetDone(target.label ?? target.peripheralKey)
            : notDone(),
        done: target != null,
        action: canOpen ? SiteStepAction.target : null,
      ),
      (
        label: l10n.siteStepMeasure,
        status: measured > 0 ? l10n.siteMeasuredCount(measured) : notDone(),
        done: measured > 0,
        action: canOpen ? SiteStepAction.measure : null,
      ),
    ];
  }
}
