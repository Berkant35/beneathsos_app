import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock.g.dart';

/// Wall clock, overridable in tests.
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;

/// Ticks once per second for elapsed-time labels.
@riverpod
Stream<DateTime> secondTicker(Ref ref) {
  final now = ref.watch(clockProvider);
  return Stream<DateTime>.periodic(const Duration(seconds: 1), (_) => now());
}
