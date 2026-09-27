import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/features/field_test/domain/device_track.dart';
import 'package:beneathsos_app/features/field_test/presentation/mixins/device_labels_mixin.dart';
import 'package:flutter/material.dart';

/// One advertiser row: kind, identity, latest RSSI, 5 s median, age.
class DeviceListTile extends StatelessWidget with DeviceLabelsMixin {
  /// Creates a row.
  const DeviceListTile({
    required this.track,
    required this.isTarget,
    required this.nowMillis,
    required this.onTap,
    required this.onToggleTarget,
    super.key,
  });

  /// Track shown.
  final DeviceTrack track;

  /// Whether the track is a marked target.
  final bool isTarget;

  /// Current wall-clock time.
  final int nowMillis;

  /// Opens the detail screen.
  final VoidCallback onTap;

  /// Marks/unmarks as target.
  final VoidCallback onToggleTarget;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final median = track.medianWithin(const Duration(seconds: 5), nowMillis);
    final age = ((nowMillis - track.lastSeenMillis) / 1000).floor().clamp(
      0,
      9999,
    );
    return ListTile(
      onTap: onTap,
      leading: IconButton(
        icon: Icon(isTarget ? Icons.star : Icons.star_border),
        onPressed: onToggleTarget,
      ),
      title: Text('${kindLabel(l10n, track.kind)} · ${shortKey(track.key)}'),
      subtitle: Text(
        '${rssiLabel(l10n, median)} · ${l10n.lastSeenSeconds(age)}',
      ),
      trailing: Text(
        rssiLabel(l10n, track.lastRssi),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
