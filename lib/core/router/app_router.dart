import 'package:beneathsos_app/features/home/presentation/screens/home_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_map_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_measure_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_notice_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_scan_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_site_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_target_screen.dart';
import 'package:beneathsos_app/features/victim/presentation/screens/victim_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Home. Its actions `go` to child routes, so Back returns here and a double tap opens one screen.
/// `/preview/...` is the roadmap 1.4 rescuer journey with sample data; each step is a child of the
/// previous one, so Back walks the journey backwards.
@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<PreviewNoticeRoute>(
      path: 'preview',
      routes: [
        TypedGoRoute<PreviewSiteRoute>(
          path: 'site',
          routes: [
            TypedGoRoute<PreviewScanRoute>(
              path: 'scan',
              routes: [
                TypedGoRoute<PreviewTargetRoute>(
                  path: 'target',
                  routes: [
                    TypedGoRoute<PreviewMeasureRoute>(
                      path: 'measure',
                      routes: [TypedGoRoute<PreviewMapRoute>(path: 'map')],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    TypedGoRoute<VictimRoute>(path: 'victim'),
  ],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  /// Route to the home screen.
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

/// Preview 1 (`/preview`): first-run notice.
class PreviewNoticeRoute extends GoRouteData with $PreviewNoticeRoute {
  /// Route to the notice.
  const PreviewNoticeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PreviewNoticeScreen();
}

/// Preview 2: rubble site outline.
class PreviewSiteRoute extends GoRouteData with $PreviewSiteRoute {
  /// Route to the outline.
  const PreviewSiteRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PreviewSiteScreen();
}

/// Preview 3: ambient scan.
class PreviewScanRoute extends GoRouteData with $PreviewScanRoute {
  /// Route to the ambient scan.
  const PreviewScanRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PreviewScanScreen();
}

/// Preview 4: choose the target.
class PreviewTargetRoute extends GoRouteData with $PreviewTargetRoute {
  /// Route to the target choice.
  const PreviewTargetRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PreviewTargetScreen();
}

/// Preview 5: measurement.
class PreviewMeasureRoute extends GoRouteData with $PreviewMeasureRoute {
  /// Route to the measurement.
  const PreviewMeasureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PreviewMeasureScreen();
}

/// Preview 6: probability map.
class PreviewMapRoute extends GoRouteData with $PreviewMapRoute {
  /// Route to the map.
  const PreviewMapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PreviewMapScreen();
}

/// Victim mode (`/victim`) — preview until roadmap phase 10.
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
