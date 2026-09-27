/// Kind of identity change seen by the scanner.
enum PresenceChange {
  /// A new identity started advertising.
  appeared,

  /// An identity has not been received for [PresencePolicy.goneAfter].
  gone,
}

/// Log entry used to observe address rotation in the field.
final class PresenceEvent {
  /// Creates an event.
  const PresenceEvent({
    required this.key,
    required this.change,
    required this.atMillis,
    required this.rssi,
  });

  /// Identity concerned.
  final String key;

  /// What happened.
  final PresenceChange change;

  /// When it happened (wall clock).
  final int atMillis;

  /// Last (gone) or first (appeared) RSSI.
  final int rssi;
}

/// Thresholds for presence detection.
abstract final class PresencePolicy {
  /// Silence after which an identity counts as gone.
  static const goneAfter = Duration(seconds: 15);

  /// Identities appearing during this warm-up are not logged as "appeared".
  static const warmUp = Duration(seconds: 5);
}
