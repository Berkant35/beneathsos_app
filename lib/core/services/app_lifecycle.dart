import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_lifecycle.g.dart';

/// App lifecycle changes (resumed, paused, …) as a stream.
///
/// Consumers listen to this in their own `build()`; `app.dart` never calls into features.
@Riverpod(keepAlive: true)
Stream<AppLifecycleState> appLifecycle(Ref ref) {
  final controller = StreamController<AppLifecycleState>();
  final listener = AppLifecycleListener(onStateChange: controller.add);
  ref.onDispose(() {
    listener.dispose();
    unawaited(controller.close());
  });
  return controller.stream;
}
