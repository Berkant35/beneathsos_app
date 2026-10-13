import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/features/probability_map/presentation/providers/map_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows or hides the signal circles; [note] says where they meet.
class SignalCirclesToggle extends ConsumerWidget {
  /// Creates the switch.
  const SignalCirclesToggle({this.note, super.key});

  /// Where the circles meet, or what is missing; shown while they are on.
  final String? note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final on = ref.watch(signalCirclesProvider);
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      value: on,
      onChanged: (_) => ref.read(signalCirclesProvider.notifier).toggle(),
      title: Text(context.l10n.circlesToggle),
      subtitle: on && note != null ? Text(note!) : null,
    );
  }
}
