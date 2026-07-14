import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import 'active_session_store.dart';
import 'collection_repository.dart';

class SessionPersistence {
  SessionPersistence(this._database);
  final AppDatabase _database;

  Future<void> finalizeActive(
    ActiveCleanupSession session, {
    DateTime? endedAt,
  }) async {
    final ended = (endedAt ?? DateTime.now().toUtc()).toUtc();
    final duration = ended
        .difference(session.startedAt)
        .inSeconds
        .clamp(0, ended.difference(session.startedAt).inSeconds);
    await _database.transaction(() async {
      final existing = await (_database.select(
        _database.cleanupSessions,
      )..where((row) => row.id.equals(session.id))).getSingleOrNull();
      if (existing != null) return;
      final key = dayKey(ended.toLocal());
      final daily = await (_database.select(
        _database.dailyEntries,
      )..where((row) => row.dateKey.equals(key))).getSingleOrNull();
      final dailyId = daily?.id ?? const Uuid().v4();
      await _database
          .into(_database.dailyEntries)
          .insertOnConflictUpdate(
            DailyEntriesCompanion.insert(
              id: dailyId,
              dateKey: key,
              count: Value((daily?.count ?? 0) + session.count),
              createdAt: daily?.createdAt ?? ended,
              updatedAt: ended,
            ),
          );
      await _database
          .into(_database.cleanupSessions)
          .insert(
            CleanupSessionsCompanion.insert(
              id: session.id,
              startedAt: session.startedAt,
              endedAt: Value(ended),
              count: Value(session.count),
              durationSeconds: Value(duration),
              locationMode: Value(session.tracking),
              notes: const Value('auto_finalized'),
              updatedAt: ended,
            ),
          );
      await _database
          .into(_database.syncOutbox)
          .insert(
            SyncOutboxCompanion.insert(
              id: const Uuid().v4(),
              entityType: 'cleanup_session',
              entityId: session.id,
              operation: 'upsert',
              payload: jsonEncode({
                'id': session.id,
                'count': session.count,
                'started_at': session.startedAt.toIso8601String(),
                'ended_at': ended.toIso8601String(),
                'location_mode': session.tracking,
                'notes': 'auto_finalized',
                'updated_at': ended.toIso8601String(),
              }),
              createdAt: ended,
            ),
          );
    });
  }
}
