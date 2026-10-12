import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:beneathsos_app/features/home/presentation/screens/home_screen.dart';
import 'package:beneathsos_app/features/sites/presentation/screens/new_site_screen.dart';
import 'package:beneathsos_app/features/victim/presentation/screens/victim_screen.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../core/scanning/fakes.dart';
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

  Future<void> pumpWith(
    WidgetTester tester, {
    BluetoothAvailability bluetooth = BluetoothAvailability.on,
    Locale locale = const Locale('en'),
    FakePermissions? permissions,
  }) => pumpRouterApp(
    tester,
    locale: locale,
    scanner: FakeScanner()..availability = bluetooth,
    permissions:
        permissions ?? FakePermissions(checkResult: ScanPermission.granted),
  );

  StatusBanner banner(WidgetTester tester) =>
      tester.widget<StatusBanner>(find.byType(StatusBanner));

  testWidgets('ready: calm banner above the actions', (tester) async {
    await pumpWith(tester);
    expect(find.text('Bluetooth is on and ready.'), findsOneWidget);
    expect(banner(tester).kind, StatusKind.ready);
    expect(
      tester.getTopLeft(find.byType(StatusBanner)).dy,
      lessThan(tester.getTopLeft(find.text('Start a search')).dy),
    );
  });

  testWidgets('Bluetooth off: red banner with the instruction, no tap action', (
    tester,
  ) async {
    await pumpWith(tester, bluetooth: BluetoothAvailability.off);
    expect(
      find.text("Bluetooth is off. Turn it on in your phone's settings."),
      findsOneWidget,
    );
    expect(banner(tester).kind, StatusKind.blocked);
    expect(banner(tester).onTap, isNull);
  });

  testWidgets('unsupported: tells the user to search with another phone', (
    tester,
  ) async {
    await pumpWith(tester, bluetooth: BluetoothAvailability.unsupported);
    expect(find.textContaining('Search with another phone'), findsOneWidget);
  });

  testWidgets('permission needed: tapping the banner asks again', (
    tester,
  ) async {
    final permissions = FakePermissions(
      checkResult: ScanPermission.denied,
      requestResult: ScanPermission.denied,
    );
    await pumpWith(tester, permissions: permissions);
    expect(
      find.text('Bluetooth permission is needed. Tap to allow it.'),
      findsOneWidget,
    );
    await tester.tap(find.byType(StatusBanner));
    await tester.pumpAndSettle();
    expect(permissions.calls.where((c) => c == 'request'), hasLength(2));
  });

  testWidgets('permission in Settings: tapping opens the settings', (
    tester,
  ) async {
    final permissions = FakePermissions(
      checkResult: ScanPermission.permanentlyDenied,
    );
    await pumpWith(tester, permissions: permissions);
    expect(
      find.textContaining('Tap to turn it on in Settings'),
      findsOneWidget,
    );
    await tester.tap(find.byType(StatusBanner));
    await tester.pumpAndSettle();
    expect(permissions.calls, contains('openSettings'));
  });

  testWidgets('Turkish banner texts', (tester) async {
    await pumpWith(tester, locale: const Locale('tr'));
    expect(find.text('Bluetooth açık ve hazır.'), findsOneWidget);
    await pumpWith(
      tester,
      locale: const Locale('tr'),
      bluetooth: BluetoothAvailability.off,
    );
    expect(
      find.text('Bluetooth kapalı. Telefonun ayarlarından açın.'),
      findsOneWidget,
    );
  });

  testWidgets('Start a search stays enabled while blocked', (tester) async {
    await pumpWith(tester, bluetooth: BluetoothAvailability.off);
    await tester.tap(find.text('Start a search'));
    await tester.pumpAndSettle();
    expect(find.byType(NewSiteScreen), findsOneWidget);
  });

  testWidgets('a failed check says so and tapping tries again', (tester) async {
    final permissions = _FailingOncePermissions();
    await pumpWith(tester, permissions: permissions);
    expect(
      find.text('Could not check Bluetooth. Tap to try again.'),
      findsOneWidget,
    );
    await tester.tap(find.byType(StatusBanner));
    await tester.pumpAndSettle();
    expect(find.text('Bluetooth is on and ready.'), findsOneWidget);
  });
}

/// Fails the first permission check like a platform error, then works.
class _FailingOncePermissions extends FakePermissions {
  _FailingOncePermissions() : super(checkResult: ScanPermission.granted);

  bool _failed = false;

  @override
  Future<ScanPermission> check() async {
    calls.add('check');
    if (!_failed) {
      _failed = true;
      throw Exception('platform error');
    }
    return checkResult;
  }
}
