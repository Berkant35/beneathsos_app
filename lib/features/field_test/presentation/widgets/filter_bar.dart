import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/theme/app_theme.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/field_test_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// RSSI threshold slider and quick filters.
class FilterBar extends ConsumerWidget {
  /// Creates the bar.
  const FilterBar({super.key});

  static const double _minRssi = -100;
  static const double _maxRssi = -30;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(fieldTestFilterProvider);
    final notifier = ref.read(fieldTestFilterProvider.notifier);
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.filterMinRssi(filter.minRssi)),
          Slider(
            min: _minRssi,
            max: _maxRssi,
            divisions: (_maxRssi - _minRssi).round(),
            value: filter.minRssi.toDouble(),
            onChanged: (v) => notifier.setMinRssi(v.round()),
          ),
          Wrap(
            spacing: AppSpacing.s,
            children: [
              FilterChip(
                label: Text(l10n.filterAppleOnly),
                selected: filter.appleOnly,
                onSelected: (_) => notifier.toggleAppleOnly(),
              ),
              FilterChip(
                label: Text(l10n.filterTargetsOnly),
                selected: filter.targetsOnly,
                onSelected: (_) => notifier.toggleTargetsOnly(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
