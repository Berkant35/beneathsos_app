import 'package:beneathsos_app/features/field_test/presentation/screens/device_detail_screen.dart';
import 'package:beneathsos_app/features/field_test/presentation/screens/field_test_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Field test tool — the M1 entry point; becomes research mode later.
@TypedGoRoute<FieldTestRoute>(
  path: '/',
  routes: [TypedGoRoute<DeviceDetailRoute>(path: 'device/:deviceKey')],
)
class FieldTestRoute extends GoRouteData with $FieldTestRoute {
  /// Route to the device list.
  const FieldTestRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FieldTestScreen();
}

/// Live RSSI of one advertiser.
class DeviceDetailRoute extends GoRouteData with $DeviceDetailRoute {
  /// Route to the detail of [deviceKey].
  const DeviceDetailRoute({required this.deviceKey});

  /// Platform identity of the advertiser.
  final String deviceKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      DeviceDetailScreen(deviceKey: deviceKey);
}

/// The app router. Only this file knows paths.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) => GoRouter(routes: $appRoutes);
