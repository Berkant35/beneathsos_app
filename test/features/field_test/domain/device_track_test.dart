import 'package:beneathsos_app/features/field_test/domain/device_kind.dart';
import 'package:beneathsos_app/features/field_test/domain/device_track.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/samples.dart';

void main() {
  test('window statistics only use readings inside the window', () {
    final track = DeviceTrack.first(sample(rssi: -90))
      ..add(sample(rssi: -60, at: 9000))
      ..add(sample(rssi: -62, at: 9500))
      ..add(sample(rssi: -64, at: 10000));

    expect(track.sampleCount, 4);
    expect(track.lastRssi, -64);
    expect(track.medianWithin(const Duration(seconds: 5), 10000), -62);
    expect(
      track.rateWithin(const Duration(seconds: 5), 10000),
      closeTo(0.6, 1e-9),
    );
  });

  test('kind is refined when manufacturer data arrives later', () {
    final track = DeviceTrack.first(sample())
      ..add(sample(companyId: 0x004C, payload: [0x12]));
    expect(track.kind, DeviceKind.appleFindMy);
  });

  test('ring buffer keeps at most capacity readings', () {
    final track = DeviceTrack.first(sample());
    for (var i = 1; i <= DeviceTrack.capacity + 10; i++) {
      track.add(sample(at: i));
    }
    expect(track.readings.length, DeviceTrack.capacity);
    expect(track.readings.first.atMillis, 11);
  });
}
