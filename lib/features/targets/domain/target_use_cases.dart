import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:rubble_core/rubble_core.dart';

/// Stores the result of the surface scan: phones on the surface are never suggested as targets.
final class CompleteAmbientScan {
  /// Creates the use case on [_store].
  const CompleteAmbientScan(this._store);

  final SessionStore _store;

  /// Stores [surface] (peripheral keys) heard during [duration] for [search].
  Future<void> call(
    SessionId search,
    List<String> surface,
    Duration duration,
  ) => _store.append(
    search,
    AmbientScanCompleted(blacklisted: surface, duration: duration),
  );
}

/// The rescuer says a listed device is on the surface (for example a team member's phone).
final class ExcludeDevice {
  /// Creates the use case on [_store].
  const ExcludeDevice(this._store);

  final SessionStore _store;

  /// Adds [peripheralKey] to the surface phones of [search].
  Future<void> call(SessionId search, String peripheralKey) => _store.append(
    search,
    BlacklistEdited(added: [peripheralKey], removed: const []),
  );
}

/// Starts following a device as a target (a device, never a person — rule 1).
final class SelectTarget {
  /// Creates the use case on [_store]; [_newId] makes target ids.
  const SelectTarget(this._store, this._newId);

  final SessionStore _store;
  final String Function() _newId;

  /// Follows [peripheralKey], shown as [label], in [search].
  Future<void> call(SessionId search, String peripheralKey, String label) =>
      _store.append(
        search,
        TargetSelected(
          target: TargetId(_newId()),
          peripheralKey: peripheralKey,
          label: label,
        ),
      );
}
