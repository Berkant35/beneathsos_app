import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_map_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_measure_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_notice_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_scan_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_site_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_target_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

Future<void> _tap(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

void main() {
  const steps = [
    ('Start a search', PreviewNoticeScreen),
    ('I understand', PreviewSiteScreen),
    ('Outline done', PreviewScanScreen),
    ('Continue', PreviewTargetScreen),
    ('Track this phone', PreviewMeasureScreen),
    ('Show the map', PreviewMapScreen),
  ];

  testWidgets(
    'the rescuer preview can be walked from home to the map and back',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      await pumpRouterApp(tester);
      for (final (button, screen) in steps) {
        await _tap(tester, button);
        expect(find.byType(screen), findsOneWidget, reason: 'after "$button"');
        expect(tester.takeException(), isNull);
        if (screen != PreviewNoticeScreen) {
          expect(
            find.text('Preview — sample data, no real measurement.'),
            findsOneWidget,
          );
        }
      }
      await _tap(tester, 'Measure here');
      expect(find.byType(PreviewMeasureScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(PreviewTargetScreen), findsOneWidget);
    },
  );

  testWidgets(
    'the walked journey is kept: back home, the card offers to continue it',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      await pumpRouterApp(tester);
      for (final (button, _) in steps) {
        await _tap(tester, button);
      }
      const HomeRoute().go(tester.element(find.byType(PreviewMapScreen)));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();
      expect(find.text('Last practice search'), findsOneWidget);
      expect(
        find.textContaining('Practice search · 1 point measured'),
        findsOneWidget,
      );
    },
  );

  testWidgets('Turkish: the same journey with Turkish labels', (tester) async {
    setPhoneSize(tester, 402, 874);
    await pumpRouterApp(tester, locale: const Locale('tr'));
    for (final label in [
      'Aramayı başlat',
      'Anladım',
      'Çizim tamam',
      'Devam et',
      'Bu telefonu izle',
      'Haritayı göster',
    ]) {
      await _tap(tester, label);
      expect(tester.takeException(), isNull, reason: 'after "$label"');
    }
    expect(find.byType(PreviewMapScreen), findsOneWidget);
    expect(find.text('Burada ölç'), findsOneWidget);
  });

  testWidgets('every preview screen survives 200 % text on a small phone', (
    tester,
  ) async {
    setPhoneSize(tester, 375, 667);
    await pumpRouterApp(tester, textScale: 2);
    for (final (button, _) in steps) {
      await _tap(tester, button);
      expect(tester.takeException(), isNull, reason: 'after "$button"');
    }
  });
}
