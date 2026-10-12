import 'package:beneathsos_app/core/scanning/presentation/providers/scan_state.dart';

/// Where the surface scan stands.
sealed class AmbientState {
  const AmbientState();
}

/// Scanning; [remaining] until the scan ends, [heard] devices so far.
final class AmbientScanning extends AmbientState {
  /// Creates the state.
  const AmbientScanning({required this.remaining, required this.heard});

  /// Time left.
  final Duration remaining;

  /// Devices heard so far.
  final int heard;
}

/// Scanning cannot run (Bluetooth off, permission missing, failed); the countdown waits.
final class AmbientBlocked extends AmbientState {
  /// Creates the state.
  const AmbientBlocked(this.scan);

  /// Why.
  final ScanState scan;
}

/// The result is being stored.
final class AmbientSaving extends AmbientState {
  /// Creates the state.
  const AmbientSaving();
}

/// Done: [setAside] surface phones will not be suggested.
final class AmbientDone extends AmbientState {
  /// Creates the state.
  const AmbientDone(this.setAside);

  /// How many phones were set aside.
  final int setAside;
}

/// The result could not be stored; the rescuer can scan again.
final class AmbientNotSaved extends AmbientState {
  /// Creates the state.
  const AmbientNotSaved();
}
