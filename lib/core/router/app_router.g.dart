// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$homeRoute];

RouteBase get $homeRoute => GoRouteData.$route(
  path: '/',
  hasOverriddenOnExit: false,
  factory: $HomeRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'onboarding',
      hasOverriddenOnExit: false,
      factory: $OnboardingRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'sites',
      hasOverriddenOnExit: false,
      factory: $SitesRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'new',
          hasOverriddenOnExit: false,
          factory: $NewSiteRoute._fromState,
        ),
        GoRouteData.$route(
          path: ':sessionId',
          hasOverriddenOnExit: false,
          factory: $SiteRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'draw',
              hasOverriddenOnExit: false,
              factory: $DrawOutlineRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'scale',
              hasOverriddenOnExit: false,
              factory: $ScaleRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    GoRouteData.$route(
      path: 'preview',
      hasOverriddenOnExit: false,
      factory: $PreviewNoticeRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'site',
          hasOverriddenOnExit: false,
          factory: $PreviewSiteRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'scan',
              hasOverriddenOnExit: false,
              factory: $PreviewScanRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'target',
                  hasOverriddenOnExit: false,
                  factory: $PreviewTargetRoute._fromState,
                  routes: [
                    GoRouteData.$route(
                      path: 'measure',
                      hasOverriddenOnExit: false,
                      factory: $PreviewMeasureRoute._fromState,
                      routes: [
                        GoRouteData.$route(
                          path: 'map',
                          hasOverriddenOnExit: false,
                          factory: $PreviewMapRoute._fromState,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRouteData.$route(
      path: 'victim',
      hasOverriddenOnExit: false,
      factory: $VictimRoute._fromState,
    ),
  ],
);

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $OnboardingRoute on GoRouteData {
  static OnboardingRoute _fromState(GoRouterState state) =>
      OnboardingRoute(from: state.uri.queryParameters['from']);

  OnboardingRoute get _self => this as OnboardingRoute;

  @override
  String get location => GoRouteData.$location(
    '/onboarding',
    queryParams: {if (_self.from != null) 'from': _self.from},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SitesRoute on GoRouteData {
  static SitesRoute _fromState(GoRouterState state) => const SitesRoute();

  @override
  String get location => GoRouteData.$location('/sites');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $NewSiteRoute on GoRouteData {
  static NewSiteRoute _fromState(GoRouterState state) => const NewSiteRoute();

  @override
  String get location => GoRouteData.$location('/sites/new');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SiteRoute on GoRouteData {
  static SiteRoute _fromState(GoRouterState state) =>
      SiteRoute(sessionId: state.pathParameters['sessionId']!);

  SiteRoute get _self => this as SiteRoute;

  @override
  String get location =>
      GoRouteData.$location('/sites/${Uri.encodeComponent(_self.sessionId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DrawOutlineRoute on GoRouteData {
  static DrawOutlineRoute _fromState(GoRouterState state) =>
      DrawOutlineRoute(sessionId: state.pathParameters['sessionId']!);

  DrawOutlineRoute get _self => this as DrawOutlineRoute;

  @override
  String get location => GoRouteData.$location(
    '/sites/${Uri.encodeComponent(_self.sessionId)}/draw',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ScaleRoute on GoRouteData {
  static ScaleRoute _fromState(GoRouterState state) =>
      ScaleRoute(sessionId: state.pathParameters['sessionId']!);

  ScaleRoute get _self => this as ScaleRoute;

  @override
  String get location => GoRouteData.$location(
    '/sites/${Uri.encodeComponent(_self.sessionId)}/scale',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PreviewNoticeRoute on GoRouteData {
  static PreviewNoticeRoute _fromState(GoRouterState state) =>
      const PreviewNoticeRoute();

  @override
  String get location => GoRouteData.$location('/preview');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PreviewSiteRoute on GoRouteData {
  static PreviewSiteRoute _fromState(GoRouterState state) =>
      const PreviewSiteRoute();

  @override
  String get location => GoRouteData.$location('/preview/site');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PreviewScanRoute on GoRouteData {
  static PreviewScanRoute _fromState(GoRouterState state) =>
      const PreviewScanRoute();

  @override
  String get location => GoRouteData.$location('/preview/site/scan');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PreviewTargetRoute on GoRouteData {
  static PreviewTargetRoute _fromState(GoRouterState state) =>
      const PreviewTargetRoute();

  @override
  String get location => GoRouteData.$location('/preview/site/scan/target');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PreviewMeasureRoute on GoRouteData {
  static PreviewMeasureRoute _fromState(GoRouterState state) =>
      const PreviewMeasureRoute();

  @override
  String get location =>
      GoRouteData.$location('/preview/site/scan/target/measure');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PreviewMapRoute on GoRouteData {
  static PreviewMapRoute _fromState(GoRouterState state) =>
      const PreviewMapRoute();

  @override
  String get location =>
      GoRouteData.$location('/preview/site/scan/target/measure/map');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $VictimRoute on GoRouteData {
  static VictimRoute _fromState(GoRouterState state) => const VictimRoute();

  @override
  String get location => GoRouteData.$location('/victim');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app router. Only this file knows paths.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// The app router. Only this file knows paths.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// The app router. Only this file knows paths.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'74417207b7e5209c4e2ce4d423dfbb54a7cad7a7';
