// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$fieldTestRoute];

RouteBase get $fieldTestRoute => GoRouteData.$route(
  path: '/',
  hasOverriddenOnExit: false,
  factory: $FieldTestRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'device/:deviceKey',
      hasOverriddenOnExit: false,
      factory: $DeviceDetailRoute._fromState,
    ),
  ],
);

mixin $FieldTestRoute on GoRouteData {
  static FieldTestRoute _fromState(GoRouterState state) =>
      const FieldTestRoute();

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

mixin $DeviceDetailRoute on GoRouteData {
  static DeviceDetailRoute _fromState(GoRouterState state) =>
      DeviceDetailRoute(deviceKey: state.pathParameters['deviceKey']!);

  DeviceDetailRoute get _self => this as DeviceDetailRoute;

  @override
  String get location =>
      GoRouteData.$location('/device/${Uri.encodeComponent(_self.deviceKey)}');

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
