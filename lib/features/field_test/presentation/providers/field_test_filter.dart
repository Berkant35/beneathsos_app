import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'field_test_filter.g.dart';

/// Device list filter.
final class FieldTestFilterState {
  /// Creates a filter.
  const FieldTestFilterState({
    this.minRssi = -100,
    this.appleOnly = false,
    this.targetsOnly = false,
  });

  /// Hide devices whose latest RSSI is below this (dBm).
  final int minRssi;

  /// Show only Apple advertisements.
  final bool appleOnly;

  /// Show only marked targets.
  final bool targetsOnly;

  /// Copy with changes.
  FieldTestFilterState copyWith({
    int? minRssi,
    bool? appleOnly,
    bool? targetsOnly,
  }) => FieldTestFilterState(
    minRssi: minRssi ?? this.minRssi,
    appleOnly: appleOnly ?? this.appleOnly,
    targetsOnly: targetsOnly ?? this.targetsOnly,
  );
}

/// Current filter.
@Riverpod(keepAlive: true)
class FieldTestFilter extends _$FieldTestFilter {
  @override
  FieldTestFilterState build() => const FieldTestFilterState();

  /// Sets the RSSI threshold.
  void setMinRssi(int value) => state = state.copyWith(minRssi: value);

  /// Toggles Apple-only.
  void toggleAppleOnly() => state = state.copyWith(appleOnly: !state.appleOnly);

  /// Toggles targets-only.
  void toggleTargetsOnly() =>
      state = state.copyWith(targetsOnly: !state.targetsOnly);
}
