import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'target_selection.g.dart';

/// Identities the tester marked as measurement targets.
@Riverpod(keepAlive: true)
class TargetSelection extends _$TargetSelection {
  @override
  Set<String> build() => const {};

  /// Adds or removes [key].
  void toggle(String key) =>
      state = state.contains(key) ? ({...state}..remove(key)) : {...state, key};

  /// Replaces [oldKey] with [newKey] after an address rotation.
  void relink(String oldKey, String newKey) => state = {...state}
    ..remove(oldKey)
    ..add(newKey);
}
