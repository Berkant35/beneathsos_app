import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/site_depth/domain/depth_input.dart';
import 'package:beneathsos_app/features/site_depth/presentation/providers/depth_providers.dart';
import 'package:beneathsos_app/features/site_depth/presentation/screens/depth_screen.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rubble_core/rubble_core.dart';

/// The depth form: the height typed, the level chosen, checking and saving them.
mixin DepthScreenMixin on ConsumerState<DepthScreen> {
  /// The height field.
  final heightController = TextEditingController();

  /// The level chosen.
  TrappedLevel level = TrappedLevel.unknown;

  /// Why the last Save was refused, if it was.
  DepthInput? refused;

  /// Whether the last Save could not store the depth.
  bool saveFailed = false;

  var _prefilled = false;

  @override
  void dispose() {
    heightController.dispose();
    super.dispose();
  }

  /// Fills the form once from what is stored.
  void prefill(RubbleDepth? stored) {
    if (_prefilled || stored == null) return;
    _prefilled = true;
    heightController.text = NumberFormat(
      '0.#',
      'en',
    ).format(stored.height.value);
    level = stored.level;
  }

  /// The error under the field, if any.
  String? errorText(AppLocalizations l10n) => switch (refused) {
    DepthNotANumber() => l10n.depthEnterNumber,
    DepthOutOfRange() => l10n.depthRange,
    _ => null,
  };

  /// Fills the field with [floors] × 3 m.
  void useFloors(int floors) => setState(() {
    heightController.text = (floors * floorM).toStringAsFixed(0);
    refused = null;
  });

  /// Checks and stores the depth, then returns to the overview.
  Future<void> save() async {
    final input = parseDepth(heightController.text);
    if (input is! DepthOk) {
      setState(() => refused = input);
      return;
    }
    setState(() => refused = null);
    try {
      await ref.read(setDepthProvider)(
        SessionId(widget.sessionId),
        input.height,
        level,
      );
      if (mounted) SiteRoute(sessionId: widget.sessionId).go(context);
    } on Object catch (error, stack) {
      AppLogger.error('depth', 'Could not store the depth', error, stack);
      if (mounted) setState(() => saveFailed = true);
    }
  }

  /// "2 floors ≈ 6 m".
  String floorsLabel(BuildContext context, int floors) =>
      context.l10n.depthFloors(floors, (floors * floorM).round());
}
