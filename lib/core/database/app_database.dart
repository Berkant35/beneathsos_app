import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// One search session per rubble site (ADR 0006). `practice` marks sessions made by the preview
/// journey or a training run; they never mix with real searches in exports.
@DataClassName('SessionRow')
class Sessions extends Table {
  /// UUIDv7.
  TextColumn get id => text()();

  /// Site name, as in `SiteCreated`.
  TextColumn get title => text()();

  /// Engine profile id, as in `SiteCreated`.
  TextColumn get engineProfile => text()();

  /// Whether this is a practice search.
  BoolColumn get practice => boolean()();

  /// Wall-clock creation time in milliseconds.
  IntColumn get createdAt => integer()();

  /// Wall-clock time of `SessionClosed` in milliseconds; null while open.
  IntColumn get closedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// The append-only event log: one row per `EventEnvelope`.
@DataClassName('EventRow')
@TableIndex(name: 'events_by_session_hlc', columns: {#sessionId, #hlc})
class Events extends Table {
  /// UUIDv7 event id.
  TextColumn get id => text()();

  /// Owning session.
  TextColumn get sessionId =>
      text().references(Sessions, #id, onDelete: KeyAction.cascade)();

  /// Sequence number per session and device, from 1.
  IntColumn get seq => integer()();

  /// Device that recorded the event.
  TextColumn get deviceId => text()();

  /// Serialised hybrid timestamp (sorts like the timestamps).
  TextColumn get hlc => text()();

  /// Envelope schema version.
  IntColumn get schema => integer()();

  /// Event type name.
  TextColumn get type => text()();

  /// Event payload as JSON.
  TextColumn get payload => text()();

  /// Wall-clock insert time in milliseconds.
  IntColumn get createdAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {sessionId, deviceId, seq},
  ];
}

/// Raw RSSI samples, inserted in batches.
@DataClassName('SampleRow')
class RssiSamples extends Table {
  /// Row id.
  IntColumn get id => integer().autoIncrement()();

  /// Owning session.
  TextColumn get sessionId =>
      text().references(Sessions, #id, onDelete: KeyAction.cascade)();

  /// Measurement point, when the sample was taken during a point measurement.
  TextColumn get pointId => text().nullable()();

  /// Advertiser identity.
  TextColumn get peripheralKey => text()();

  /// Received signal strength in dBm.
  IntColumn get rssi => integer()();

  /// Advertised TX power.
  IntColumn get txPower => integer().nullable()();

  /// Bluetooth SIG company id.
  IntColumn get companyId => integer().nullable()();

  /// Monotonic receive time in nanoseconds.
  IntColumn get tMonoNs => integer()();

  /// Wall-clock receive time in milliseconds.
  IntColumn get tWall => integer()();
}

/// Small key–value settings (device id, onboarding done, …).
@DataClassName('SettingRow')
class Settings extends Table {
  /// Setting name.
  TextColumn get key => text()();

  /// Setting value.
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// The app's SQLite database.
@DriftDatabase(tables: [Sessions, Events, RssiSamples, Settings])
class AppDatabase extends _$AppDatabase {
  /// Opens the database on [executor] (a file on the phone, in memory in tests).
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // Events are evidence: rows are appended, never changed (deleting a session cascades).
      await customStatement('''
        CREATE TRIGGER events_append_only BEFORE UPDATE ON events
        BEGIN SELECT RAISE(ABORT, 'events are append-only'); END
      ''');
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      // Write-ahead log: a crash mid-write never loses a committed event (ADR 0006).
      await customStatement('PRAGMA journal_mode = WAL');
    },
  );
}
