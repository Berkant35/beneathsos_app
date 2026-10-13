import 'package:rubble_core/rubble_core.dart';

/// What the rescuer typed as the rubble height.
sealed class DepthInput {
  const DepthInput();
}

/// A usable height.
final class DepthOk extends DepthInput {
  /// Creates the result.
  const DepthOk(this.height);

  /// The height.
  final Meters height;
}

/// Not a number.
final class DepthNotANumber extends DepthInput {
  /// Creates the result.
  const DepthNotANumber();
}

/// Outside [minDepthM]–[maxDepthM].
final class DepthOutOfRange extends DepthInput {
  /// Creates the result.
  const DepthOutOfRange();
}

/// Lowest rubble height accepted (metres).
const minDepthM = 0.5;

/// Highest rubble height accepted (metres).
const maxDepthM = 100.0;

/// About this much rubble per collapsed floor (metres).
const floorM = 3.0;

/// Reads [text] as metres ("6", "4.5" or "4,5").
DepthInput parseDepth(String text) {
  final value = double.tryParse(text.trim().replaceAll(',', '.'));
  if (value == null || !value.isFinite) return const DepthNotANumber();
  if (value < minDepthM || value > maxDepthM) return const DepthOutOfRange();
  return DepthOk(Meters(value));
}
