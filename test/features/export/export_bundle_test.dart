import 'dart:convert';

import 'package:beneathsos_app/core/sessions/domain/search_record.dart';
import 'package:beneathsos_app/features/export/domain/export_bundle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_core/rubble_core.dart';

Map<String, Object?> _event(
  int seq,
  String type,
  Map<String, Object?> payload,
) => {
  'schema': 1,
  'id': 'e$seq',
  'session': 's1',
  'seq': seq,
  'hlc': '000000000${1000 + seq}-0000-d1',
  'type': type,
  'payload': payload,
};

void main() {
  final record = SearchRecord(
    id: 's1',
    title: 'Atatürk Cad. 12, "B" blok',
    engineProfile: 'voided_pancake@1',
    practice: false,
    createdAt: DateTime.utc(2026, 10, 13, 3, 4),
    events: [
      _event(1, 'TargetSelected', {
        'target': 't1',
        'peripheralKey': 'apple-1',
        'label': 'Find My',
      }),
      _event(2, 'TargetRelinked', {
        'target': 't1',
        'from': 'apple-1',
        'to': 'apple-2',
      }),
      // A row that no longer decodes is exported as stored, never dropped.
      {..._event(3, 'Mystery', {}), 'payload': '{broken'},
    ],
    samples: const [
      (
        point: 'p1',
        key: 'apple-1',
        rssi: -80,
        txPower: null,
        companyId: 76,
        tMonoNs: 1,
        tWall: 2,
      ),
      (
        point: 'p1',
        key: 'apple-2',
        rssi: -81,
        txPower: 4,
        companyId: 76,
        tMonoNs: 3,
        tWall: 4,
      ),
      (
        point: 'p1',
        key: 'bystander',
        rssi: -60,
        txPower: null,
        companyId: null,
        tMonoNs: 5,
        tWall: 6,
      ),
      (
        point: null,
        key: 'bystander',
        rssi: -61,
        txPower: null,
        companyId: null,
        tMonoNs: 7,
        tWall: 8,
      ),
    ],
  );

  ExportBundle build({List<int> salt = const [1, 2, 3]}) => ExportBundle.build(
    record,
    exportedAt: DateTime.utc(2026, 10, 13, 9),
    disclaimer: 'Supports, never replaces, professional search and rescue.',
    salt: salt,
  );

  test(
    'the JSON carries the disclaimer, the search and every event as stored',
    () {
      final json = jsonDecode(build().json) as Map<String, Object?>;
      expect(json['schema'], 1);
      expect(json['disclaimer'], contains('never replaces'));
      expect(json['exportedAt'], '2026-10-13T09:00:00.000Z');
      expect((json['search']! as Map)['engineProfile'], 'voided_pancake@1');
      final events = json['events']! as List;
      expect(events, hasLength(3));
      expect(
        EventEnvelope.fromJson(events.first! as Map<String, Object?>).event,
        isA<TargetSelected>(),
      );
      expect((events.last! as Map)['payload'], '{broken');
    },
  );

  test(
    'target keys stay; other phones are hashed, stable within one export',
    () {
      final rows = const LineSplitter().convert(build().csv);
      expect(
        rows.first,
        'point_id,device,rssi,tx_power,company_id,t_mono_ns,t_wall',
      );
      expect(rows[1], 'p1,apple-1,-80,,76,1,2');
      expect(rows[2], startsWith('p1,apple-2,')); // the target after its relink
      final bystander = rows[3].split(',')[1];
      expect(bystander, matches(RegExp(r'^other-[0-9a-f]{12}$')));
      expect(rows[4].split(',')[1], bystander);
      expect(rows[4], startsWith(',other-'));
      expect(build().csv, isNot(contains('bystander')));
    },
  );

  test('a new export draws a new salt: the same phone is not linkable across files', () {
    String hashed(ExportBundle b) =>
        const LineSplitter().convert(b.csv)[3].split(',')[1];
    expect(hashed(build(salt: [9, 9, 9])), isNot(hashed(build())));
  });

  test('file names: date and a safe title', () {
    expect(build().baseName, 'beneathsos-2026-10-13-ataturk-cad-12-b-blok');
  });
}
