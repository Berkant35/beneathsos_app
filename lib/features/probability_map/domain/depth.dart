import 'dart:math' as math;

import 'package:locator_engine/locator_engine.dart';
import 'package:rubble_core/rubble_core.dart';

/// How high above the ground the phone may be, as fractions of the rubble height, for the level the
/// rescuers gave; null when they do not know (the profile's spread stays). A basement counts as ground
/// level: the slab above it is more rubble.
List<double>? levelFractions(TrappedLevel level) => switch (level) {
  TrappedLevel.upper => const [0.7, 0.9],
  TrappedLevel.middle => const [0.4, 0.6],
  TrappedLevel.bottom => const [0.1, 0.25],
  TrappedLevel.basement => const [0.0],
  TrappedLevel.unknown => null,
};

/// [base] with the rescuers' [depth] — the rubble height and the phone's likely heights — in place of
/// the profile's guess; [base] itself without one. The signal cannot tell depth (rule 2): it only
/// comes from here.
EngineProfile withDepth(EngineProfile base, RubbleDepth? depth) {
  if (depth == null) return base;
  return EngineProfile(
    id: base.id,
    txPowerAt1mDbm: base.txPowerAt1mDbm,
    thresholdDbm: base.thresholdDbm,
    slowFadingDb: base.slowFadingDb,
    fastFadingDb: base.fastFadingDb,
    offsetSdDb: base.offsetSdDb,
    offsetsDb: base.offsetsDb,
    linkVariation: base.linkVariation,
    pathLossExponents: base.pathLossExponents,
    attenuationDbPerM: base.attenuationDbPerM,
    rubbleHeightM: depth.height.value,
    victimHeightFractions:
        levelFractions(depth.level) ?? base.victimHeightFractions,
    cellM: base.cellM,
  );
}

/// The phone's typical height above the ground under [profile] (the mean of its likely heights).
Meters phoneHeight(EngineProfile profile) {
  final fractions = profile.victimHeightFractions;
  return Meters(
    profile.rubbleHeightM *
        fractions.reduce((a, b) => a + b) /
        fractions.length,
  );
}

/// A slant distance [slant] to a phone [height] above the ground, seen from above (on the map);
/// at least 0.3 m.
Meters horizontalRadius(Meters slant, Meters height) {
  final square = slant.value * slant.value - height.value * height.value;
  return Meters(math.max(math.sqrt(math.max(square, 0)), 0.3));
}
