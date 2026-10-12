import 'package:beneathsos_app/features/sites/domain/site_name.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a name is trimmed', () {
    expect(checkSiteName('  Atatürk Cad. 12 ').name, 'Atatürk Cad. 12');
  });

  test('spaces only is empty', () {
    expect(checkSiteName('   ').problem, isA<EmptySiteName>());
  });

  test(
    '80 characters fit, 81 do not (counted as characters, not UTF-16 units)',
    () {
      expect(checkSiteName('ş' * 80).name, hasLength(80));
      expect(checkSiteName('ş' * 81).problem, isA<SiteNameTooLong>());
    },
  );
}
