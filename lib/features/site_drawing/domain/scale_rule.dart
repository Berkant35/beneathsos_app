import 'package:rubble_core/rubble_core.dart';

/// Why a typed real length cannot be used.
enum RealLengthProblem {
  /// Empty or not a number.
  notANumber,

  /// Outside 0.5–500 m.
  outOfRange,
}

/// Shortest real side accepted.
const minRealLength = Meters(0.5);

/// Longest real side accepted.
const maxRealLength = Meters(500);

/// The scale factor (`ScaleSet`) for a side drawn [drawn] long that is [typed] metres in reality, or the
/// problem with what was typed. A decimal comma is accepted.
({double? factor, RealLengthProblem? problem}) checkRealLength(
  String typed, {
  required Meters drawn,
}) {
  final real = double.tryParse(typed.trim().replaceAll(',', '.'));
  if (real == null || !real.isFinite) {
    return (factor: null, problem: RealLengthProblem.notANumber);
  }
  if (real < minRealLength.value || real > maxRealLength.value) {
    return (factor: null, problem: RealLengthProblem.outOfRange);
  }
  return (factor: real / drawn.value, problem: null);
}

/// The index of the longest side (from corner `i` to the next) — the easiest one to measure.
int longestSide(RubblePolygon outline) {
  final edges = outline.edges;
  var longest = 0;
  for (var i = 1; i < edges.length; i++) {
    if (edges[i].length.value > edges[longest].length.value) longest = i;
  }
  return longest;
}

/// Whether [factor] changes every length so much that a typo is more likely than a real correction
/// (a sketch is rarely off by more than half or double); the rescuer is asked before it is stored.
bool isUnusualScale(double factor) => factor < 0.5 || factor > 2;
