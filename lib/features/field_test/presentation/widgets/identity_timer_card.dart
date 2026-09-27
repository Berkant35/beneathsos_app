import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/theme/app_theme.dart';
import 'package:beneathsos_app/features/field_test/domain/device_track.dart';
import 'package:beneathsos_app/features/field_test/domain/presence_event.dart';
import 'package:beneathsos_app/features/field_test/presentation/mixins/device_labels_mixin.dart';
import 'package:beneathsos_app/features/field_test/presentation/mixins/identity_timer_mixin.dart';
import 'package:flutter/material.dart';

/// How long this identity has been stable, with rotation warnings.
class IdentityTimerCard extends StatelessWidget
    with DeviceLabelsMixin, IdentityTimerMixin {
  /// Creates the card.
  const IdentityTimerCard({
    required this.track,
    required this.nowMillis,
    super.key,
  });

  /// Track shown.
  final DeviceTrack track;

  /// Current wall-clock time.
  final int nowMillis;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final age = Duration(
      milliseconds: track.lastSeenMillis - track.firstSeenMillis,
    );
    final silentSeconds = ((nowMillis - track.lastSeenMillis) / 1000).floor();
    final gone = silentSeconds * 1000 > PresencePolicy.goneAfter.inMilliseconds;
    final color = timerColor(scheme, age);
    return Card(
      child: Padding(
        padding: AppSpacing.page,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.detailFirstSeen(clockLabel(age)),
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(color: color),
            ),
            const SizedBox(height: AppSpacing.s),
            LinearProgressIndicator(
              value: (age.inSeconds / const Duration(minutes: 15).inSeconds)
                  .clamp(0, 1),
              color: color,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              gone ? l10n.detailGone(silentSeconds) : l10n.detailRotationHint,
            ),
          ],
        ),
      ),
    );
  }
}
