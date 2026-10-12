import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/site_drawing/domain/save_outline_result.dart';
import 'package:beneathsos_app/features/site_drawing/domain/set_outline.dart';
import 'package:beneathsos_app/features/site_drawing/domain/set_scale.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubble_canvas/rubble_canvas.dart';
import 'package:rubble_core/rubble_core.dart';

part 'drawing_providers.g.dart';

/// Stores the outline of a search.
@Riverpod(keepAlive: true)
SetOutline setOutline(Ref ref) => SetOutline(ref.watch(sessionStoreProvider));

/// Stores the scale of a search.
@Riverpod(keepAlive: true)
SetScale setScale(Ref ref) => SetScale(ref.watch(sessionStoreProvider));

/// The outline being drawn for one search, starting from the stored one.
@riverpod
class OutlineDraftController extends _$OutlineDraftController {
  RubblePolygon? _stored;
  var _saving = false;

  @override
  Future<OutlineDraft> build(String sessionId) async {
    final search = await ref
        .watch(sessionStoreProvider)
        .watch(SessionId(sessionId))
        .first;
    _stored = search.outline;
    final stored = _stored;
    return stored == null
        ? const OutlineDraft.empty()
        : OutlineDraft.from(stored);
  }

  /// Whether the drawing differs from the stored outline (Back then asks before it is lost).
  bool get hasUnsavedChanges => !listEquals(
    state.value?.corners ?? const [],
    _stored?.corners ?? const [],
  );

  /// The rescuer changed the drawing.
  void change(OutlineDraft next) => state = AsyncData(next);

  /// Stores the outline when it is valid and changed.
  Future<SaveOutlineResult> save() async {
    final polygon = state.value?.polygon;
    if (polygon == null) return const OutlineNotValid();
    if (polygon == _stored) return const OutlineSaved();
    if (_saving) return const OutlineSaveRunning();
    _saving = true;
    try {
      await ref.read(setOutlineProvider).call(SessionId(sessionId), polygon);
      _stored = polygon;
      return const OutlineSaved();
    } on Exception catch (error, stack) {
      AppLogger.error('drawing', 'Could not store the outline', error, stack);
      return const OutlineNotSaved();
    } finally {
      _saving = false;
    }
  }
}
