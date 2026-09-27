import 'package:flutter/material.dart';

/// Colour thresholds for the address-rotation timer.
mixin IdentityTimerMixin {
  /// Warning from this age on.
  static const warnAfter = Duration(minutes: 10);

  /// Critical from this age on.
  static const criticalAfter = Duration(minutes: 13);

  /// Colour for an identity of [age].
  Color timerColor(ColorScheme scheme, Duration age) {
    if (age >= criticalAfter) return scheme.error;
    if (age >= warnAfter) return scheme.tertiary;
    return scheme.primary;
  }
}
