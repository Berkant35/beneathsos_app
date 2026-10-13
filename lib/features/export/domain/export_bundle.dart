import 'dart:convert';

import 'package:beneathsos_app/core/sessions/domain/search_record.dart';
import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

/// The two export files of a search, each carrying the disclaimer (rule 5). Nothing is dropped; the
/// identities of phones that are not targets are replaced by salted hashes in both files (bystanders,
/// the rescue team — `docs/architecture.md` §8).
@immutable
final class ExportBundle {
  const ExportBundle._(this.baseName, this.json, this.csv);

  /// Builds the files of [record]; [salt] is drawn fresh for every export, so a bystander's hash links
  /// readings within one file but never across files.
  factory ExportBundle.build(
    SearchRecord record, {
    required DateTime exportedAt,
    required String disclaimer,
    required List<int> salt,
  }) {
    final targets = _targetKeys(record.events);
    final codes = <String, String>{};
    String device(String key) => targets.contains(key)
        ? key
        : codes.putIfAbsent(
            key,
            () =>
                'other-${sha256.convert([...salt, ...utf8.encode(key)]).toString().substring(0, 12)}',
          );
    final json = const JsonEncoder.withIndent(' ').convert({
      'schema': 1,
      'generator': 'BeneathSOS',
      'exportedAt': exportedAt.toUtc().toIso8601String(),
      'disclaimer': disclaimer,
      'search': {
        'id': record.id,
        'title': record.title,
        'engineProfile': record.engineProfile,
        'practice': record.practice,
        'createdAt': record.createdAt.toUtc().toIso8601String(),
        'closedAt': record.closedAt?.toUtc().toIso8601String(),
      },
      'events': [for (final e in record.events) _private(e, device)],
    });
    final csv = StringBuffer()
      ..writeAll([for (final line in disclaimer.split('\n')) '# $line\n'])
      ..write('point_id,device,rssi,tx_power,company_id,t_mono_ns,t_wall\n');
    for (final s in record.samples) {
      csv.writeln(
        [
          s.point ?? '',
          device(s.key),
          s.rssi,
          s.txPower ?? '',
          s.companyId ?? '',
          s.tMonoNs,
          s.tWall,
        ].map((v) => _csvField('$v')).join(','),
      );
    }
    final date = record.createdAt.toIso8601String().substring(0, 10);
    final slug = _slug(record.title);
    return ExportBundle._(
      slug.isEmpty ? 'beneathsos-$date' : 'beneathsos-$date-$slug',
      json,
      csv.toString(),
    );
  }

  /// File name without extension: `beneathsos-2026-10-13-ataturk-cad-12`.
  final String baseName;

  /// The search and its events (`.json`).
  final String json;

  /// The raw readings (`-samples.csv`).
  final String csv;
}

/// [event] with every key of a phone that is not a target replaced by its [device] code: the surface
/// scan and blacklist edits list them. A row that no longer decodes may hold keys too: its text is
/// left out and the row marked `unreadable` (type, id, order and time stay).
Map<String, Object?> _private(
  Map<String, Object?> event,
  String Function(String key) device,
) {
  List<Object?> coded(Object? keys) => [
    for (final k in keys is List ? keys : const <Object?>[])
      k is String ? device(k) : k,
  ];
  return switch ((event['type'], event['payload'])) {
    (_, String()) => {...event, 'payload': null, 'unreadable': true},
    ('AmbientScanCompleted', final Map<String, Object?> p) => {
      ...event,
      'payload': {...p, 'blacklisted': coded(p['blacklisted'])},
    },
    ('BlacklistEdited', final Map<String, Object?> p) => {
      ...event,
      'payload': {
        ...p,
        'added': coded(p['added']),
        'removed': coded(p['removed']),
      },
    },
    _ => event,
  };
}

/// Every peripheral key a target had (selected, or relinked from and to).
Set<String> _targetKeys(List<Map<String, Object?>> events) => {
  for (final e in events)
    if (e['payload'] case final Map<String, Object?> p)
      ...switch (e['type']) {
        'TargetSelected' => [p['peripheralKey']],
        'TargetRelinked' => [p['from'], p['to']],
        _ => const <Object?>[],
      }.whereType<String>(),
};

String _csvField(String v) =>
    v.contains(RegExp(r'[",\n]')) ? '"${v.replaceAll('"', '""')}"' : v;

const _plain = {
  'ç': 'c', 'ğ': 'g', 'ı': 'i', 'i̇': 'i', 'ö': 'o', 'ş': 's', 'ü': 'u', //
  'â': 'a', 'î': 'i', 'û': 'u',
};

String _slug(String title) {
  var s = title.replaceAll('İ', 'i').toLowerCase();
  _plain.forEach((from, to) => s = s.replaceAll(from, to));
  s = s.replaceAll(RegExp('[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-|-$'), '');
  return s.length > 40 ? s.substring(0, 40).replaceAll(RegExp(r'-$'), '') : s;
}
