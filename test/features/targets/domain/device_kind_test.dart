import 'package:beneathsos_app/features/targets/domain/device_kind.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/samples.dart';

void main() {
  test('Apple Find My is recognised by type byte 0x12', () {
    expect(
      classify(sample(companyId: 0x004C, payload: [0x12, 0x19])),
      DeviceKind.appleFindMy,
    );
  });

  test('Apple Nearby Info is recognised by type byte 0x10', () {
    expect(
      classify(sample(companyId: 0x004C, payload: [0x10, 0x05])),
      DeviceKind.appleNearby,
    );
  });

  test('Apple without payload is appleOther', () {
    expect(classify(sample(companyId: 0x004C)), DeviceKind.appleOther);
  });

  test('other companies and missing data', () {
    expect(
      classify(sample(companyId: 0x0075, payload: [1])),
      DeviceKind.samsung,
    );
    expect(classify(sample(companyId: 0x1234, payload: [1])), DeviceKind.other);
    expect(classify(sample()), DeviceKind.unknown);
  });
}
