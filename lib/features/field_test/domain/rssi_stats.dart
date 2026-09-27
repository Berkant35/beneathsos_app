import 'dart:math' as math;

/// Median of [values]; `null` when empty.
double? median(List<int> values) {
  if (values.isEmpty) return null;
  final sorted = [...values]..sort();
  final mid = sorted.length ~/ 2;
  return sorted.length.isOdd
      ? sorted[mid].toDouble()
      : (sorted[mid - 1] + sorted[mid]) / 2;
}

/// Sample standard deviation of [values]; `null` with fewer than two values.
double? standardDeviation(List<int> values) {
  if (values.length < 2) return null;
  final mean = values.reduce((a, b) => a + b) / values.length;
  final variance =
      values.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) /
      (values.length - 1);
  return math.sqrt(variance);
}
