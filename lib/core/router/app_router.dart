import 'package:beneathsos_app/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Home — temporary until the entry flow (roadmap phase 4).
@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData with $HomeRoute {
  /// Route to the home screen.
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

/// The app router. Only this file knows paths.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) => GoRouter(routes: $appRoutes);
