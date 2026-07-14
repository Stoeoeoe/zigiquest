import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

String dayKey([DateTime? value]) =>
    DateFormat('yyyy-MM-dd').format((value ?? DateTime.now()).toLocal());

class CollectionRepository {
  CollectionRepository(this.db, {Future<void> Function()? onLocalWrite})
    : _onLocalWrite = onLocalWrite;
  final AppDatabase db;
  final Future<void> Function()? _onLocalWrite;
  final _uuid = const Uuid();
  Future<void> _pending = Future<void>.value();
  Stream<List<DailyEntry>> watchAll() => db.watchDays();

  Future<void> setCount(DateTime date, int value) async {
    final key = dayKey(date);
    final now = DateTime.now();
    final safe = value < 0 ? 0 : value;
    await db.transaction(() async {
      final old = await (db.select(
        db.dailyEntries,
      )..where((t) => t.dateKey.equals(key))).getSingleOrNull();
      final id = old?.id ?? _uuid.v4();
      await db
          .into(db.dailyEntries)
          .insertOnConflictUpdate(
            DailyEntriesCompanion.insert(
              id: id,
              dateKey: key,
              count: Value(safe),
              createdAt: old?.createdAt ?? now,
              updatedAt: now,
            ),
          );
      await db
          .into(db.syncOutbox)
          .insert(
            SyncOutboxCompanion.insert(
              id: _uuid.v4(),
              entityType: 'daily_collection',
              entityId: id,
              operation: 'upsert',
              payload: jsonEncode({
                'id': id,
                'date_key': key,
                'count': safe,
                'updated_at': now.toUtc().toIso8601String(),
              }),
              createdAt: now,
            ),
          );
    });
    final trigger = _onLocalWrite;
    if (trigger != null) unawaited(trigger());
  }

  Future<void> change(DateTime date, int delta) {
    final operation = _pending.then((_) async {
      final current = await db.countFor(dayKey(date));
      await setCount(date, current + delta);
    });
    _pending = operation.then<void>((_) {}, onError: (_) {});
    return operation;
  }

  Future<int> total() async => (await db.select(db.dailyEntries).get())
      .where((entry) => entry.deletedAt == null)
      .fold<int>(0, (sum, entry) => sum + entry.count);
}
