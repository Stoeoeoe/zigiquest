import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import 'photo_cloud_service.dart';

class SyncService {
  SyncService(this.db, this.client);
  final AppDatabase db;
  final SupabaseClient? client;

  Future<SyncResult> synchronize({int batchSize = 50}) async {
    if (client == null || client!.auth.currentUser == null) {
      return const SyncResult();
    }
    final uploaded = await flush(batchSize: batchSize);
    final pulled = await _pullRemoteChanges();
    return SyncResult(uploaded: uploaded, pulled: pulled);
  }

  Future<int> flush({int batchSize = 50}) async {
    if (client == null || client!.auth.currentUser == null) return 0;
    final queued =
        await (db.select(db.syncOutbox)
              ..where((item) => item.status.equals('pending'))
              ..orderBy([(item) => OrderingTerm.asc(item.createdAt)]))
            .get();
    final now = DateTime.now();
    final pending = queued
        .where(
          (item) => item.nextRetryAt == null || !item.nextRetryAt!.isAfter(now),
        )
        .take(batchSize)
        .toList();
    pending.sort(
      (left, right) =>
          _priority(left.entityType).compareTo(_priority(right.entityType)),
    );
    var done = 0;
    for (final operation in pending) {
      try {
        if (operation.entityType == 'session_photo') {
          final photo =
              await (db.select(db.sessionPhotos)
                    ..where((item) => item.id.equals(operation.entityId)))
                  .getSingleOrNull();
          if (photo == null ||
              await PhotoCloudService(db, client).upload(photo)) {
            await _complete(operation.id);
            done++;
          }
          continue;
        }
        final payload = jsonDecode(operation.payload) as Map<String, dynamic>;
        payload['user_id'] = client!.auth.currentUser!.id;
        if (operation.entityType == 'daily_collection') {
          await client!.rpc(
            'sync_daily_collection',
            params: {
              'p_id': payload['id'],
              'p_date_key': payload['date_key'],
              'p_count': payload['count'],
              'p_updated_at': payload['updated_at'],
            },
          );
        } else {
          await client!.from('cleanup_sessions').upsert(payload);
        }
        await _complete(operation.id);
        done++;
      } catch (error) {
        await _fail(operation, error);
      }
    }
    return done;
  }

  Future<int> _pullRemoteChanges() async {
    final remoteDays = await client!
        .from('daily_collections')
        .select('id,date_key,count,created_at,updated_at,deleted_at');
    final remoteSessions = await client!
        .from('cleanup_sessions')
        .select(
          'id,started_at,ended_at,count,duration_seconds,distance_meters,'
          'location_mode,approximate_latitude,approximate_longitude,'
          'route_polyline,notes,updated_at,deleted_at',
        );
    final pending = await (db.select(
      db.syncOutbox,
    )..where((item) => item.status.equals('pending'))).get();
    final pendingDays = <String>{};
    final pendingSessions = <String>{};
    for (final item in pending) {
      if (item.entityType == 'daily_collection') {
        try {
          pendingDays.add(
            (jsonDecode(item.payload) as Map<String, dynamic>)['date_key']
                as String,
          );
        } catch (_) {
          // The outbox will retry malformed payloads independently.
        }
      } else if (item.entityType == 'cleanup_session') {
        pendingSessions.add(item.entityId);
      }
    }
    var merged = 0;
    await db.transaction(() async {
      for (final raw in remoteDays as List<dynamic>) {
        final row = raw as Map<String, dynamic>;
        final dateKey = row['date_key'] as String;
        if (pendingDays.contains(dateKey)) continue;
        final remoteUpdated = _date(row['updated_at']);
        final local = await (db.select(
          db.dailyEntries,
        )..where((entry) => entry.dateKey.equals(dateKey))).getSingleOrNull();
        if (local != null && !remoteUpdated.isAfter(local.updatedAt.toUtc())) {
          continue;
        }
        final deletedAt = _nullableDate(row['deleted_at']);
        if (local == null) {
          await db
              .into(db.dailyEntries)
              .insert(
                DailyEntriesCompanion.insert(
                  id: row['id'] as String,
                  dateKey: dateKey,
                  count: Value((row['count'] as num).toInt()),
                  createdAt: _date(row['created_at']),
                  updatedAt: remoteUpdated,
                  deletedAt: Value(deletedAt),
                ),
              );
        } else {
          await (db.update(
            db.dailyEntries,
          )..where((entry) => entry.dateKey.equals(dateKey))).write(
            DailyEntriesCompanion(
              count: Value((row['count'] as num).toInt()),
              updatedAt: Value(remoteUpdated),
              deletedAt: Value(deletedAt),
            ),
          );
        }
        merged++;
      }
      for (final raw in remoteSessions as List<dynamic>) {
        final row = raw as Map<String, dynamic>;
        final id = row['id'] as String;
        if (pendingSessions.contains(id)) continue;
        final remoteUpdated = _date(row['updated_at']);
        final local = await (db.select(
          db.cleanupSessions,
        )..where((session) => session.id.equals(id))).getSingleOrNull();
        if (local != null && !remoteUpdated.isAfter(local.updatedAt.toUtc())) {
          continue;
        }
        final companion = CleanupSessionsCompanion(
          startedAt: Value(_date(row['started_at'])),
          endedAt: Value(_nullableDate(row['ended_at'])),
          count: Value((row['count'] as num).toInt()),
          durationSeconds: Value((row['duration_seconds'] as num?)?.toInt()),
          distanceMeters: Value((row['distance_meters'] as num?)?.toDouble()),
          locationMode: Value(
              (row['location_mode'] as String) == 'point'
                  ? 'route'
                  : row['location_mode'] as String,
            ),
          approximateLatitude: Value(
            (row['approximate_latitude'] as num?)?.toDouble(),
          ),
          approximateLongitude: Value(
            (row['approximate_longitude'] as num?)?.toDouble(),
          ),
          routeJson: Value(row['route_polyline'] as String?),
          notes: Value(row['notes'] as String?),
          updatedAt: Value(remoteUpdated),
          deletedAt: Value(_nullableDate(row['deleted_at'])),
        );
        if (local == null) {
          await db
              .into(db.cleanupSessions)
              .insert(companion.copyWith(id: Value(id)));
        } else {
          await (db.update(
            db.cleanupSessions,
          )..where((session) => session.id.equals(id))).write(companion);
        }
        merged++;
      }
    });
    return merged;
  }

  DateTime _date(Object? value) => DateTime.parse(value as String).toUtc();
  DateTime? _nullableDate(Object? value) => value == null ? null : _date(value);

  int _priority(String entityType) => switch (entityType) {
    'daily_collection' => 0,
    'cleanup_session' => 1,
    'session_photo' => 2,
    _ => 3,
  };

  Future<void> _complete(String id) =>
      (db.update(db.syncOutbox)..where((item) => item.id.equals(id))).write(
        const SyncOutboxCompanion(
          status: Value('completed'),
          lastError: Value(null),
        ),
      );

  Future<void> _fail(SyncOutboxData operation, Object error) {
    final attempts = operation.attemptCount + 1;
    return (db.update(
      db.syncOutbox,
    )..where((item) => item.id.equals(operation.id))).write(
      SyncOutboxCompanion(
        status: const Value('pending'),
        attemptCount: Value(attempts),
        lastError: Value('$error'),
        nextRetryAt: Value(
          DateTime.now().add(Duration(minutes: 1 << attempts.clamp(0, 6))),
        ),
      ),
    );
  }

  Future<void> deleteAccount() async {
    final user = client?.auth.currentUser;
    if (user == null) throw StateError('Nicht angemeldet');
    await client!.rpc('delete_own_account');
    await client!.auth.signOut();
  }
}

class SyncResult {
  const SyncResult({this.uploaded = 0, this.pulled = 0});
  final int uploaded;
  final int pulled;
}
