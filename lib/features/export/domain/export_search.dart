import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:beneathsos_app/core/sharing/share_port.dart';
import 'package:beneathsos_app/features/export/domain/export_bundle.dart';
import 'package:rubble_core/rubble_core.dart';

/// Builds the export files of a search and offers them to the share sheet.
final class ExportSearch {
  /// Creates the use case.
  const ExportSearch(
    this._store,
    this._share, {
    required this._now,
    required this._salt,
  });

  final SessionStore _store;
  final SharePort _share;
  final DateTime Function() _now;
  final List<int> Function() _salt;

  /// Exports [session] with [disclaimer] in the files; [subject] names it in the share sheet. False
  /// when the person closed the sheet without sharing.
  Future<bool> call(
    SessionId session, {
    required String disclaimer,
    required String subject,
  }) async {
    final bundle = ExportBundle.build(
      await _store.record(session),
      exportedAt: _now(),
      disclaimer: disclaimer,
      salt: _salt(),
    );
    return _share.share([
      (
        name: '${bundle.baseName}.json',
        mimeType: 'application/json',
        text: bundle.json,
      ),
      (
        name: '${bundle.baseName}-samples.csv',
        mimeType: 'text/csv',
        text: bundle.csv,
      ),
    ], subject: subject);
  }
}
