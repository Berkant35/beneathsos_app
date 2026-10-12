import 'package:beneathsos_app/core/formatting/measures.dart';
import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/site_drawing/domain/scale_rule.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/providers/drawing_providers.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/screens/scale_screen.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/widgets/unusual_scale_dialog.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rubble_core/rubble_core.dart';

/// The chosen side, the typed real length and how it was measured (form state only).
mixin ScaleScreenMixin on ConsumerState<ScaleScreen> {
  /// The real length being typed.
  final lengthController = TextEditingController();

  /// The side the rescuer chose; null = the longest.
  int? chosenSide;

  /// How the real length was measured.
  ScaleSource source = ScaleSource.tape;

  /// What is wrong with the typed length after the last Save.
  RealLengthProblem? problem;

  /// Whether the last Save could not store the scale.
  bool failed = false;

  var _saving = false;

  /// The side to measure in [outline].
  int sideOf(RubblePolygon outline) => chosenSide ?? longestSide(outline);

  /// The error under the field, if any.
  String? errorText(AppLocalizations l10n) => switch (problem) {
    RealLengthProblem.notANumber => l10n.scaleNotANumber,
    RealLengthProblem.outOfRange => l10n.scaleOutOfRange,
    null => failed ? l10n.scaleNotSaved : null,
  };

  /// "Tape measure", "Paced steps", "Estimate".
  String sourceLabel(AppLocalizations l10n, ScaleSource source) =>
      switch (source) {
        ScaleSource.tape => l10n.scaleTape,
        ScaleSource.steps => l10n.scaleSteps,
        ScaleSource.estimate => l10n.scaleEstimate,
      };

  /// Checks the length, stores the scale and returns to the overview.
  Future<void> save(RubblePolygon outline) async {
    final drawn = outline.edges[sideOf(outline)].length;
    final checked = checkRealLength(lengthController.text, drawn: drawn);
    setState(() {
      problem = checked.problem;
      failed = false;
    });
    final factor = checked.factor;
    if (factor == null || _saving) return;
    if (isUnusualScale(factor) && !await _confirmUnusual(factor, drawn)) return;
    if (!mounted) return;
    _saving = true;
    try {
      await ref
          .read(setScaleProvider)
          .call(SessionId(widget.sessionId), factor, source);
      if (mounted) SiteRoute(sessionId: widget.sessionId).go(context);
    } on Exception catch (error, stack) {
      AppLogger.error('drawing', 'Could not store the scale', error, stack);
      if (mounted) setState(() => failed = true);
    } finally {
      _saving = false;
    }
  }

  Future<bool> _confirmUnusual(double factor, Meters drawn) {
    final l10n = AppLocalizations.of(context);
    return UnusualScaleDialog.confirm(
      context,
      factor: NumberFormat('0.0', l10n.localeName).format(factor),
      real: metresLabel(l10n, Meters(drawn.value * factor)),
    );
  }

  @override
  void dispose() {
    lengthController.dispose();
    super.dispose();
  }
}
