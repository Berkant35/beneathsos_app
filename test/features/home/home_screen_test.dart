import 'package:beneathsos_app/features/home/presentation/screens/home_screen.dart';
import 'package:beneathsos_app/features/sites/presentation/screens/new_site_screen.dart';
import 'package:beneathsos_app/features/victim/presentation/screens/victim_screen.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void _smallPhone(WidgetTester tester) {
  tester.view
    ..physicalSize =
        const Size(750, 1334) // 375 × 667 at 2×
    ..devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

Future<void> _expectReachable(WidgetTester tester, String label) async {
  await tester.dragUntilVisible(
    find.text(label),
    find.byType(SingleChildScrollView),
    const Offset(0, -200),
  );
  expect(find.text(label).hitTestable(), findsOneWidget);
}

void main() {
  testWidgets('English: logo, message, both actions and the fine print', (
    tester,
  ) async {
    await pumpRouterApp(tester);
    expect(find.bySemanticsLabel('BeneathSOS'), findsOneWidget);
    expect(find.text('Search for a phone under rubble'), findsOneWidget);
    expect(find.text('Start a search'), findsOneWidget);
    expect(find.text('I am trapped'), findsOneWidget);
    expect(find.textContaining('not affiliated with AFAD'), findsOneWidget);
    expect(find.text('Powered by Socrepho'), findsOneWidget);
  });

  testWidgets('Turkish', (tester) async {
    await pumpRouterApp(tester, locale: const Locale('tr'));
    expect(find.text('Enkaz altındaki bir telefonu arayın'), findsOneWidget);
    expect(find.text('Aramayı başlat'), findsOneWidget);
    expect(find.text('Enkaz altındayım'), findsOneWidget);
    expect(
      find.textContaining('AFAD veya herhangi bir kamu kurumuyla'),
      findsOneWidget,
    );
    expect(find.text('Powered by Socrepho'), findsOneWidget);
  });

  testWidgets('Start a search opens the new-site screen; Back returns home', (
    tester,
  ) async {
    await pumpRouterApp(tester);
    await tester.tap(find.text('Start a search'));
    await tester.pumpAndSettle();
    expect(find.byType(NewSiteScreen), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('the Back button is a 56 px target for gloved hands', (
    tester,
  ) async {
    await pumpRouterApp(tester);
    await tester.tap(find.text('Start a search'));
    await tester.pumpAndSettle();
    final back = tester.getSize(find.byType(BackButton));
    expect(back.shortestSide, greaterThanOrEqualTo(56));
  });

  testWidgets('I am trapped opens the victim screen with the 112 note', (
    tester,
  ) async {
    await pumpRouterApp(tester);
    await tester.tap(find.text('I am trapped'));
    await tester.pumpAndSettle();
    expect(find.byType(VictimScreen), findsOneWidget);
    expect(find.textContaining('call 112'), findsOneWidget);
  });

  testWidgets(
    'a gloved double tap opens one screen and Back still returns home',
    (tester) async {
      await pumpRouterApp(tester);
      await tester.tap(find.text('Start a search'));
      await tester.tap(find.text('Start a search'), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    },
  );

  testWidgets(
    '200 % text on a small phone: no overflow, both actions reachable',
    (tester) async {
      _smallPhone(tester);
      await pumpRouterApp(tester, textScale: 2);
      expect(tester.takeException(), isNull);
      await _expectReachable(tester, 'Start a search');
      await _expectReachable(tester, 'I am trapped');
    },
  );

  testWidgets('Turkish at 200 % on a small phone: labels wrap, nothing clips', (
    tester,
  ) async {
    _smallPhone(tester);
    await pumpRouterApp(tester, locale: const Locale('tr'), textScale: 2);
    expect(tester.takeException(), isNull);
    await _expectReachable(tester, 'Aramayı başlat');
    await _expectReachable(tester, 'Enkaz altındayım');
  });

  testWidgets('dark mode draws the logo in dark-theme colours', (tester) async {
    await pumpRouterApp(tester, theme: BeneathTheme.dark());
    final painter = tester
        .widgetList<CustomPaint>(
          find.descendant(
            of: find.byType(BeneathLogo),
            matching: find.byType(CustomPaint),
          ),
        )
        .map((paint) => paint.painter)
        .whereType<SignalExitPainter>()
        .single;
    expect(
      (painter.line, painter.accent),
      (BeneathColors.primaryDark, BeneathColors.accentDark),
    );
  });

  testWidgets('screen readers hear both actions as buttons', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpRouterApp(tester);
    for (final label in ['Start a search', 'I am trapped']) {
      expect(
        tester.getSemantics(find.bySemanticsLabel(label)),
        isSemantics(label: label, isButton: true),
      );
    }
    handle.dispose();
  });
}
