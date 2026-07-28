import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class DailyEntries extends Table {
  TextColumn get id => text()();
  TextColumn get dateKey => text().unique()();
  IntColumn get count => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class CleanupSessions extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get count => integer().withDefault(const Constant(0))();
  IntColumn get durationSeconds => integer().nullable()();
  RealColumn get distanceMeters => real().nullable()();
  TextColumn get locationMode => text().withDefault(const Constant('none'))();
  RealColumn get approximateLatitude => real().nullable()();
  RealColumn get approximateLongitude => real().nullable()();
  TextColumn get routeJson => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class AppPreferences extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  BoolColumn get hapticsEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get soundEnabled => boolean().withDefault(const Constant(false))();
  BoolColumn get reducedMotion =>
      boolean().withDefault(const Constant(false))();
  TextColumn get containerStyle =>
      text().withDefault(const Constant('glass_jar'))();
  BoolColumn get cloudPhotoBackup =>
      boolean().withDefault(const Constant(false))();
  TextColumn get locationDefault =>
      text().withDefault(const Constant('none'))();
  IntColumn get userSeed => integer().withDefault(const Constant(7319))();
  IntColumn get pileLimit => integer().withDefault(const Constant(100))();
  BoolColumn get environmentEffectsEnabled =>
      boolean().withDefault(const Constant(true))();
  TextColumn get locale => text().withDefault(const Constant('en'))();
  @override
  Set<Column> get primaryKey => {id};
}

class SyncOutbox extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get nextRetryAt => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  @override
  Set<Column> get primaryKey => {id};
}

class SessionPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get path => text()();
  TextColumn get type => text()();
  IntColumn get width => integer()();
  IntColumn get height => integer()();
  IntColumn get sizeBytes => integer()();
  BoolColumn get uploaded => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class UnlockRecords extends Table {
  TextColumn get key => text()();
  DateTimeColumn get unlockedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {key};
}

class MilestoneRecords extends Table {
  TextColumn get key => text()();
  DateTimeColumn get achievedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    DailyEntries,
    CleanupSessions,
    AppPreferences,
    SyncOutbox,
    SessionPhotos,
    UnlockRecords,
    MilestoneRecords,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);
  AppDatabase.memory() : super(NativeDatabase.memory());
  static AppDatabase open() => AppDatabase(
    LazyDatabase(() async {
      final d = await getApplicationDocumentsDirectory();
      return NativeDatabase.createInBackground(
        File(p.join(d.path, 'zigiquest.sqlite')),
      );
    }),
  );
  @override
  int get schemaVersion => 5;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(appPreferences, appPreferences.pileLimit);
      }
      if (from < 3) {
        await migrator.addColumn(
          appPreferences,
          appPreferences.environmentEffectsEnabled,
        );
      }
      if (from < 4) {
        await migrator.addColumn(appPreferences, appPreferences.locale);
      }
    },
  );
  Future<void> normalizeLegacyLocationModes() => customStatement(
    "UPDATE cleanup_sessions SET location_mode = 'route' WHERE location_mode = 'point'",
  );
  Future<int> countFor(String day) async =>
      (await (select(
        dailyEntries,
      )..where((t) => t.dateKey.equals(day))).getSingleOrNull())?.count ??
      0;
  Stream<List<DailyEntry>> watchDays() =>
      (select(dailyEntries)
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.dateKey)]))
          .watch();
  Stream<List<SessionPhoto>> watchSessionPhotos(String sessionId) =>
      (select(sessionPhotos)
            ..where((photo) => photo.sessionId.equals(sessionId))
            ..orderBy([(photo) => OrderingTerm.asc(photo.createdAt)]))
          .watch();
  Stream<AppPreference> watchSettings() =>
      (select(
        appPreferences,
      )..where((t) => t.id.equals(1))).watchSingleOrNull().map(
        (e) =>
            e ??
            const AppPreference(
              id: 1,
              themeMode: 'system',
              hapticsEnabled: true,
              soundEnabled: false,
              reducedMotion: false,
              containerStyle: 'glass_jar',
              cloudPhotoBackup: false,
              locationDefault: 'none',
              userSeed: 7319,
              pileLimit: 100,
              environmentEffectsEnabled: true,
              locale: 'en',
            ),
      );
}

final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError(),
);
