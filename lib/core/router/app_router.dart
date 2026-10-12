import 'package:beneathsos_app/features/home/presentation/screens/home_screen.dart';
import 'package:beneathsos_app/features/sites/presentation/screens/new_site_screen.dart';
import 'package:beneathsos_app/features/victim/presentation/screens/victim_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Home. Its actions `go` to child routes, so Back returns here and a double tap opens one screen.
@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<NewSiteRoute>(path: 'sites/new'),
    TypedGoRoute<VictimRoute>(path: 'victim'),
  ],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  /// Route to the home screen.
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

/// Rescuer flow start (`/sites/new`) — "being prepared" until roadmap phase 4.
class NewSiteRoute extends GoRouteData with $NewSiteRoute {
  /// Route to the new-site screen.
  const NewSiteRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NewSiteScreen();
}

/// Victim mode (`/victim`) — "being prepared" until roadmap phase 10.
class VictimRoute extends GoRouteData with $VictimRoute {
  /// Route to the victim screen.
  const VictimRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const VictimScreen();
}

/// The app router. Only this file knows paths.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) => GoRouter(routes: $appRoutes);
