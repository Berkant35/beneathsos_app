import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:rubble_core/rubble_core.dart';

/// One step of the rescuer flow on the overview.
typedef SiteStep = ({String label, String status, bool done});

/// The steps of a search, from its projected state.
mixin SiteScreenMixin {
  /// Outline, surface phones, target, measured points — each done or still to come. [state] is null
  /// while loading or when stored data cannot be read.
  List<SiteStep> stepsFor(AppLocalizations l10n, SessionState? state) {
    SiteStep step(String label, {required bool done}) => (
      label: label,
      status: done ? l10n.siteStepDone : l10n.siteStepNext,
      done: done,
    );
    final measured = state?.measuredPoints.length ?? 0;
    return [
      step(l10n.siteStepOutline, done: state?.outline != null),
      step(l10n.siteStepAmbient, done: state?.blacklist.isNotEmpty ?? false),
      step(l10n.siteStepTarget, done: state?.targets.isNotEmpty ?? false),
      (
        label: l10n.siteStepMeasure,
        status: measured > 0
            ? l10n.siteMeasuredCount(measured)
            : l10n.siteStepNext,
        done: measured > 0,
      ),
    ];
  }
}
