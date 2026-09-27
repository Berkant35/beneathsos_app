import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/theme/app_theme.dart';
import 'package:beneathsos_app/features/field_test/domain/device_track.dart';
import 'package:flutter/material.dart';

/// Raw advertisement details for analysis.
class PayloadCard extends StatelessWidget {
  /// Creates the card.
  const PayloadCard({required this.track, super.key});

  /// Track shown.
  final DeviceTrack track;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final payload = track.lastPayload;
    final hex = payload == null
        ? l10n.noValue
        : payload.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
    final company = track.companyId;
    return Card(
      child: Padding(
        padding: AppSpacing.page,
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(track.key),
              Text(
                '${l10n.detailCompany}: ${company == null ? l10n.noValue : '0x${company.toRadixString(16).padLeft(4, '0')}'}',
              ),
              Text('${l10n.detailName}: ${track.localName ?? l10n.noValue}'),
              Text('${l10n.detailPayload}: $hex'),
            ],
          ),
        ),
      ),
    );
  }
}
