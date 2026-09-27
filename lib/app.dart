import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/core/theme/app_theme.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/scan_controller.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root widget: theme, localisation, router and app-lifecycle hooks.
class BeneathSosApp extends ConsumerStatefulWidget {
  /// Creates the app.
  const BeneathSosApp({super.key});

  @override
  ConsumerState<BeneathSosApp> createState() => _BeneathSosAppState();
}

class _BeneathSosAppState extends ConsumerState<BeneathSosApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(scanControllerProvider.notifier).onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    routerConfig: ref.watch(appRouterProvider),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  );
}
