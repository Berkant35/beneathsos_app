import 'package:beneathsos_app/core/settings/domain/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_core/rubble_core.dart';

void main() {
  test('nothing stored: the defaults', () {
    final s = AppSettings.read((_) => null);
    expect(s.language, AppLanguage.system);
    expect(s.defaultProfile, 'voided_pancake@1');
    expect(s.signalCircles, isTrue);
    expect(s.measureDuration, const Duration(seconds: 15));
    expect(s.defaultRubbleHeight, const Meters(4));
  });

  test('stored values are read back', () {
    final stored = {
      AppSettings.languageKey: 'turkish',
      AppSettings.profileKey: 'dense@1',
      AppSettings.circlesKey: 'false',
      AppSettings.measureKey: '30',
      AppSettings.heightKey: '9',
    };
    final s = AppSettings.read((key) => stored[key]);
    expect(s.language, AppLanguage.turkish);
    expect(s.defaultProfile, 'dense@1');
    expect(s.signalCircles, isFalse);
    expect(s.measureDuration, const Duration(seconds: 30));
    expect(s.defaultRubbleHeight, const Meters(9));
  });

  test(
    'a broken or unknown value falls back to its default, never a crash',
    () {
      final stored = {
        AppSettings.languageKey: 'klingon',
        AppSettings.profileKey: 'nope@9',
        AppSettings.circlesKey: 'maybe',
        AppSettings.measureKey: '7',
        AppSettings.heightKey: '-3',
      };
      final s = AppSettings.read((key) => stored[key]);
      expect(s, AppSettings.read((_) => null));
    },
  );
}
