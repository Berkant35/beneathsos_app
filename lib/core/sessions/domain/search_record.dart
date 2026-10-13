import 'package:meta/meta.dart';

/// One stored raw reading.
typedef StoredSample = ({
  String? point,
  String key,
  int rssi,
  int? txPower,
  int? companyId,
  int tMonoNs,
  int tWall,
});

/// A search as stored: its row, every event envelope (payload decoded, or the stored text when it no
/// longer decodes) and its raw readings.
@immutable
final class SearchRecord {
  /// Creates a record.
  const SearchRecord({
    required this.id,
    required this.title,
    required this.engineProfile,
    required this.practice,
    required this.createdAt,
    required this.events,
    required this.samples,
    this.closedAt,
  });

  /// Session id.
  final String id;

  /// Site name.
  final String title;

  /// Engine profile id.
  final String engineProfile;

  /// Practice search.
  final bool practice;

  /// Created (wall clock).
  final DateTime createdAt;

  /// Finished, if it is.
  final DateTime? closedAt;

  /// Event envelopes in stored order.
  final List<Map<String, Object?>> events;

  /// Raw readings in stored order.
  final List<StoredSample> samples;
}
