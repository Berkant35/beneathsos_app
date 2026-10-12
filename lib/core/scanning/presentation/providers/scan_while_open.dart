import 'dart:async';

import 'package:beneathsos_app/core/scanning/presentation/providers/scan_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_while_open.g.dart';

/// Scans while a screen that needs it is open (surface scan, candidates); shared, so moving from one
/// to the other never stops the scan in between.
@riverpod
Future<void> scanWhileOpen(Ref ref) async {
  final scanner = ref.read(scanControllerProvider.notifier);
  // Stopping touches other providers, which a dispose callback may not do: stop right after it.
  ref.onDispose(() => unawaited(Future.microtask(scanner.stop)));
  await scanner.start();
}
