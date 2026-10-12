import 'package:beneathsos_app/app.dart';
import 'package:beneathsos_app/features/home/presentation/screens/home_screen.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the app uses the BeneathSOS theme', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BeneathSosApp()));
    await tester.pumpAndSettle();
    final theme = Theme.of(tester.element(find.byType(HomeScreen)));
    expect(theme.colorScheme.primary, BeneathColors.primaryLight);
    expect(theme.extension<BeneathTokens>(), isNotNull);
  });
}
