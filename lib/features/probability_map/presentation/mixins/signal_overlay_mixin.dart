import 'package:beneathsos_app/core/canvas/canvas_style.dart';
import 'package:beneathsos_app/core/formatting/measures.dart';
import 'package:beneathsos_app/features/probability_map/domain/map_request.dart';
import 'package:beneathsos_app/features/probability_map/domain/signal_circles.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/painting.dart';
import 'package:rubble_canvas/rubble_canvas.dart';
import 'package:rubble_core/rubble_core.dart';

/// The signal circles of one target on the drawing: a circle per point where it was heard (in its own
/// colour), the distance from the nearest such point to where the circles meet inside the rubble, and
/// the colour of each point.
typedef SignalOverlay = ({
  List<MapCircle> circles,
  MapMeasure? measure,
  Map<PointId, Color> colors,
  String? note,
});

/// Builds the signal-circle layer (ADR 0019: a rough guide beside the probability map).
mixin SignalOverlayMixin {
  /// The layer for [target] of [search]; empty when [visible] is false or nothing was heard.
  SignalOverlay signalOverlay(
    AppLocalizations l10n,
    SessionState search,
    TargetId? target, {
    required bool visible,
  }) {
    const none = (
      circles: <MapCircle>[],
      measure: null,
      colors: <PointId, Color>{},
      note: null,
    );
    final outline = realOutline(search);
    if (!visible || target == null || outline == null) return none;
    final profile = profileFor(search);
    final scale = search.scale;
    final heard = [
      for (final point in search.measuredPoints)
        if (point.at case final at?)
          for (final reading in point.readings)
            if (reading case SignalHeard(target: final t, :final median)
                when t == target)
              (point.id, at, signalRadius(median, profile)),
    ];
    if (heard.isEmpty) return none;
    final colors = {
      for (final (i, (id, _, _)) in heard.indexed)
        id: signalCircleColors[i % signalCircleColors.length],
    };
    final circles = [
      for (final (id, at, radius) in heard)
        (centre: at, radius: Meters(radius.value / scale), color: colors[id]!),
    ];
    final meet = meetingPoint([
      for (final (_, at, radius) in heard) (toReal(at, scale), radius),
    ], outline);
    if (meet == null) {
      return (
        circles: circles,
        measure: null,
        colors: colors,
        note: l10n.circlesOne,
      );
    }
    final (_, nearest, _) = heard.reduce(
      (a, b) =>
          toReal(a.$2, scale).distanceTo(meet).value <=
              toReal(b.$2, scale).distanceTo(meet).value
          ? a
          : b,
    );
    final distance = metresLabel(l10n, toReal(nearest, scale).distanceTo(meet));
    return (
      circles: circles,
      measure: (from: nearest, to: toDrawn(meet, scale), label: distance),
      colors: colors,
      note: l10n.circlesMeet(distance),
    );
  }
}
