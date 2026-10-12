import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:meta/meta.dart';
import 'package:rubble_core/rubble_core.dart';

/// A short description of a session for lists and the home screen.
@immutable
final class SessionSummary {
  /// Creates a summary.
  const SessionSummary({
    required this.id,
    required this.title,
    required this.practice,
    required this.createdAt,
    required this.measuredPoints,
  });

  /// Session id.
  final SessionId id;

  /// Site name.
  final String title;

  /// Whether this is a practice search (preview journey, training).
  final bool practice;

  /// When the session was created (wall clock).
  final DateTime createdAt;

  /// Points with readings that were not discarded.
  final int measuredPoints;

  @override
  bool operator ==(Object other) =>
      other is SessionSummary &&
      other.id == id &&
      other.title == title &&
      other.practice == practice &&
      other.createdAt == createdAt &&
      other.measuredPoints == measuredPoints;

  @override
  int get hashCode =>
      Object.hash(id, title, practice, createdAt, measuredPoints);
}

/// A stored event that no longer decodes. It is reported, never skipped (rule 3: no data is lost).
final class UnreadableEvent implements Exception {
  /// Creates the error.
  const UnreadableEvent(this.eventId, this.message);

  /// The stored event.
  final EventId eventId;

  /// Why it does not decode.
  final String message;

  @override
  String toString() => 'Stored event ${eventId.value} is unreadable: $message';
}

/// Event-sourced sessions (ADR 0006): every action is an event appended in its own transaction;
/// screens show the projection of the events.
abstract interface class SessionStore {
  /// Creates a session and appends its `SiteCreated` event, atomically.
  Future<SessionId> create({
    required String title,
    required String engineProfile,
    required bool practice,
  });

  /// Appends [event] to [session] with the next sequence number and a hybrid timestamp.
  Future<void> append(SessionId session, SessionEvent event);

  /// The projected state of [session], updated after every append.
  Stream<SessionState> watch(SessionId session);

  /// The most recently created session that is not closed, or null.
  Stream<SessionSummary?> watchLatestOpen();

  /// Stores raw samples heard during [session] (at [point], when measuring one) in one batch.
  Future<void> addSamples(
    SessionId session,
    PointId? point,
    List<BleSample> samples,
  );
}
