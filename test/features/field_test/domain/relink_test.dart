import 'package:beneathsos_app/features/field_test/domain/presence_event.dart';
import 'package:beneathsos_app/features/field_test/domain/relink.dart';
import 'package:flutter_test/flutter_test.dart';

PresenceEvent _e(String key, PresenceChange c, int at, int rssi) =>
    PresenceEvent(key: key, change: c, atMillis: at, rssi: rssi);

void main() {
  test(
    'suggests identities appearing near the time the target went silent',
    () {
      // Target last seen at 100 s (gone event is logged 15 s later).
      final events = [
        _e('NEW', PresenceChange.appeared, 102000, -74),
        _e('FAR', PresenceChange.appeared, 180000, -73),
        _e('LOUD', PresenceChange.appeared, 101000, -50),
        _e('T', PresenceChange.gone, 115000, -72),
      ];

      final result = suggestRelinks(targetKey: 'T', events: events);

      expect(result.map((c) => c.key), ['NEW']);
      expect(result.single.gapSeconds, 2);
      expect(result.single.rssiDelta, 2);
    },
  );

  test('no suggestion while the target is still present', () {
    final events = [_e('NEW', PresenceChange.appeared, 1000, -70)];
    expect(suggestRelinks(targetKey: 'T', events: events), isEmpty);
  });
}
