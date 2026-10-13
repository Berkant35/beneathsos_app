import 'package:beneathsos_app/core/disclaimer/disclaimer.dart';
import 'package:beneathsos_app/features/export/presentation/screens/export_screen.dart';
import 'package:beneathsos_app/features/home/presentation/screens/home_screen.dart';
import 'package:beneathsos_app/features/measurement/presentation/screens/measure_screen.dart';
import 'package:beneathsos_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_map_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_measure_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_notice_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_scan_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_site_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_target_screen.dart';
import 'package:beneathsos_app/features/probability_map/presentation/screens/map_screen.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/screens/draw_outline_screen.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/screens/scale_screen.dart';
import 'package:beneathsos_app/features/sites/presentation/screens/new_site_screen.dart';
import 'package:beneathsos_app/features/sites/presentation/screens/site_screen.dart';
import 'package:beneathsos_app/features/sites/presentation/screens/sites_screen.dart';
import 'package:beneathsos_app/features/targets/presentation/screens/ambient_scan_screen.dart';
import 'package:beneathsos_app/features/targets/presentation/screens/targets_screen.dart';
import 'package:beneathsos_app/features/victim/presentation/screens/victim_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Home. Its actions `go` to child routes, so Back returns here and a double tap opens one screen.
/// `/sites/...` is the rescuer flow, behind the first-run disclaimer (`/onboarding`); victim mode is
/// never behind it. `/preview/...` is the roadmap 1.4 journey with sample data ("practice"); each step
/// is a child of the previous one, so Back walks the journey backwards.
@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<OnboardingRoute>(path: 'onboarding'),
    TypedGoRoute<SitesRoute>(
      path: 'sites',
      routes: [
        TypedGoRoute<NewSiteRoute>(path: 'new'),
        TypedGoRoute<SiteRoute>(
          path: ':sessionId',
          routes: [
            TypedGoRoute<DrawOutlineRoute>(path: 'draw'),
            TypedGoRoute<ScaleRoute>(path: 'scale'),
            TypedGoRoute<AmbientRoute>(path: 'ambient'),
            TypedGoRoute<TargetsRoute>(path: 'targets'),
            TypedGoRoute<MeasureRoute>(path: 'measure'),
            TypedGoRoute<MapRoute>(path: 'map'),
            TypedGoRoute<ExportRoute>(path: 'export'),
          ],
        ),
      ],
    ),
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

/// First run of the rescuer flow (`/onboarding?from=`): the disclaimer, then [from] (a `/sites`
/// location the rescuer was going to) or the list.
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  /// Route to onboarding.
  const OnboardingRoute({this.from});

  /// Where to continue after the disclaimer.
  final String? from;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      OnboardingScreen(from: from);
}

/// After the disclaimer: continue to [from] when it is a rescuer-flow location, else the list.
void continueAfterDisclaimer(BuildContext context, String? from) {
  final target = from ?? '';
  if (target.startsWith(const SitesRoute().location)) {
    GoRouter.of(context).go(target);
  } else {
    const SitesRoute().go(context);
  }
}

/// The rescuer's searches (`/sites`). It and its children wait for the disclaimer state (read from
/// the database the first time), so a returning rescuer never sees it again; an error counts as
/// "not accepted".
class SitesRoute extends GoRouteData with $SitesRoute {
  /// Route to the list.
  const SitesRoute();

  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final container = ProviderScope.containerOf(context, listen: false);
    bool accepted;
    try {
      accepted = await container.read(disclaimerProvider.future);
    } on Exception {
      accepted = false;
    }
    return accepted
        ? null
        : OnboardingRoute(from: state.uri.toString()).location;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SitesScreen();
}

/// A new search (`/sites/new`).
class NewSiteRoute extends GoRouteData with $NewSiteRoute {
  /// Route to the form.
  const NewSiteRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NewSiteScreen();
}

/// One search (`/sites/:sessionId`).
class SiteRoute extends GoRouteData with $SiteRoute {
  /// Route to the overview of [sessionId].
  const SiteRoute({required this.sessionId});

  /// The search.
  final String sessionId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SiteScreen(sessionId: sessionId);
}

/// Draw the rubble outline (`/sites/:sessionId/draw`).
class DrawOutlineRoute extends GoRouteData with $DrawOutlineRoute {
  /// Route to the drawing of [sessionId].
  const DrawOutlineRoute({required this.sessionId});

  /// The search.
  final String sessionId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      DrawOutlineScreen(sessionId: sessionId);
}

/// Correct the scale with one real measurement (`/sites/:sessionId/scale`).
class ScaleRoute extends GoRouteData with $ScaleRoute {
  /// Route to the scale step of [sessionId].
  const ScaleRoute({required this.sessionId});

  /// The search.
  final String sessionId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ScaleScreen(sessionId: sessionId);
}

/// The 30 s surface scan (`/sites/:sessionId/ambient`).
class AmbientRoute extends GoRouteData with $AmbientRoute {
  /// Route to the surface scan of [sessionId].
  const AmbientRoute({required this.sessionId});

  /// The search.
  final String sessionId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AmbientScanScreen(sessionId: sessionId);
}

/// Choose the phone to search for (`/sites/:sessionId/targets`).
class TargetsRoute extends GoRouteData with $TargetsRoute {
  /// Route to the candidates of [sessionId].
  const TargetsRoute({required this.sessionId});

  /// The search.
  final String sessionId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      TargetsScreen(sessionId: sessionId);
}

/// Measure at points around the rubble (`/sites/:sessionId/measure`).
class MeasureRoute extends GoRouteData with $MeasureRoute {
  /// Route to measuring in [sessionId].
  const MeasureRoute({required this.sessionId});

  /// The search.
  final String sessionId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MeasureScreen(sessionId: sessionId);
}

/// The probability map of a search (`/sites/:sessionId/map`).
class MapRoute extends GoRouteData with $MapRoute {
  /// Route to the map of [sessionId].
  const MapRoute({required this.sessionId});

  /// The search.
  final String sessionId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MapScreen(sessionId: sessionId);
}

/// Export a search (`/sites/:sessionId/export`).
class ExportRoute extends GoRouteData with $ExportRoute {
  /// Route to the export of [sessionId].
  const ExportRoute({required this.sessionId});

  /// The search.
  final String sessionId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ExportScreen(sessionId: sessionId);
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
