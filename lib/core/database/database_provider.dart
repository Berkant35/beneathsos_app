import 'dart:async';

import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

/// The app database file `beneathsos` in the app's documents folder; closed with the scope.
/// Tests override it with an in-memory database.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase(driftDatabase(name: 'beneathsos'));
  ref.onDispose(() => unawaited(db.close()));
  return db;
}
