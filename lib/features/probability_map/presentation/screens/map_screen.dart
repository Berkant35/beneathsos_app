import 'dart:async';

import 'package:beneathsos_app/core/canvas/canvas_style.dart';
import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/probability_map/presentation/mixins/map_mixin.dart';
import 'package:beneathsos_app/features/probability_map/presentation/providers/map_providers.dart';
import 'package:beneathsos_app/features/probability_map/presentation/widgets/map_panel.dart';
import 'package:beneathsos_app/features/research/presentation/providers/research_providers.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubble_canvas/rubble_canvas.dart';
import 'package:rubble_core/rubble_core.dart';

/// The hub of a search (roadmap 9): where the phone most likely is, as 50 % / 90 % regions, the points
/// measured and the suggested next point. The map runs edge to edge (`padded: false`).
class MapScreen extends ConsumerStatefulWidget {
  /// Creates the screen for [sessionId].
  const MapScreen({required this.sessionId, super.key});

  /// The search.
  final String sessionId;

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with MapMixin {
  /// The target shown (form state only); null = the first one.
  TargetId? _chosen;

  /// Recording where the phone was found (form state).
  _Found _found = _Found.idle;

  Future<void> _record(TargetId target, SitePoint at) async {
    try {
      await ref.read(recordFoundProvider)(
        SessionId(widget.sessionId),
        target,
        at,
      );
      if (mounted) setState(() => _found = _Found.idle);
    } on Object catch (error, stack) {
      AppLogger.error(
        'research',
        'Could not record the found spot',
        error,
        stack,
      );
      if (mounted) setState(() => _found = _Found.failed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final search = ref.watch(sessionStateProvider(widget.sessionId)).value;
    final targets = search?.targets ?? const <TargetId, TargetState>{};
    final target = _chosen ?? targets.keys.firstOrNull;
    final page = BeneathSpacing.pageFor(MediaQuery.sizeOf(context).width);
    final map = target == null
        ? null
        : ref.watch(probabilityMapProvider(widget.sessionId, target.value));
    Widget message(String text, {StatusKind kind = StatusKind.attention}) =>
        Padding(
          padding: page,
          child: StatusBanner(kind: kind, message: text),
        );
    return BeneathScaffold(
      title: l10n.probTitle,
      padded: false,
      body: switch ((search?.outline, map)) {
        (_, null) || (null, _) => message(l10n.probNeedsPoint),
        (_, final AsyncValue<TargetMap?> value) when value.hasError => message(
          l10n.probFailed,
        ),
        (_, AsyncData(value: null)) => message(l10n.probNeedsPoint),
        (final outline?, AsyncData(value: final TargetMap result)) =>
          LayoutBuilder(
            builder: (context, constraints) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (targets.length > 1)
                  Padding(
                    padding: page.copyWith(bottom: BeneathSpacing.sm),
                    child: Wrap(
                      spacing: BeneathSpacing.sm,
                      children: [
                        for (final MapEntry(:key, :value) in targets.entries)
                          ChoiceChip(
                            label: Text(value.label ?? value.peripheralKey),
                            selected: key == target,
                            onSelected: (_) => setState(() => _chosen = key),
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  child: SiteMap(
                    outline: outline,
                    points: pointsOf(search!, target!, result.result.next),
                    heat: heatOf(result.result.map, search.scale),
                    style: canvasStyleOf(Theme.of(context)),
                    semanticLabel: areas(l10n, result.result.map),
                    onTap: _found == _Found.tapping
                        ? (at) => unawaited(_record(target!, at))
                        : null,
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight / 2,
                  ),
                  child: SingleChildScrollView(
                    padding: page.copyWith(top: BeneathSpacing.m),
                    child: MapPanel(
                      sessionId: widget.sessionId,
                      map: result,
                      onRecordFound: () =>
                          setState(() => _found = _Found.tapping),
                      note: switch (_found) {
                        _Found.tapping => l10n.probTapFound,
                        _Found.failed => l10n.probRecordFailed,
                        _Found.idle => foundLine(
                          l10n,
                          search,
                          target!,
                          result.result.map,
                        ),
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        _ => message(l10n.probCalculating, kind: StatusKind.ready),
      },
    );
  }
}

/// Where recording the found spot stands.
enum _Found {
  /// Not recording.
  idle,

  /// Waiting for the tap on the map.
  tapping,

  /// The last record could not be saved.
  failed,
}
