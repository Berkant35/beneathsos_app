import 'package:beneathsos_app/features/targets/domain/presence_event.dart';

/// Thresholds for tracking advertisers. All time rules of the tracker live here.
final class TrackerPolicy {
  /// Creates a policy; defaults are the field values.
  const TrackerPolicy({
    this.warmUp = PresencePolicy.warmUp,
    this.goneAfter = PresencePolicy.goneAfter,
    this.forgetAfter = const Duration(seconds: 30),
    this.maxEvents = 500,
  });

  /// Identities first heard during this period after the first sample are not logged as
  /// "appeared" — they were already around when scanning started.
  final Duration warmUp;

  /// Silence after which a "gone" event is logged once.
  final Duration goneAfter;

  /// Silence after which an identity is dropped from the device list (the log keeps it).
  final Duration forgetAfter;

  /// The presence log keeps only the newest [maxEvents] entries.
  final int maxEvents;
}
