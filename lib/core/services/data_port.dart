import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

enum ImportMergeMode { replaceAll, keepExisting, importedValuesWin }

class DataPort {
  DataPort(this.db);
  final AppDatabase db;
  Future<String> exportJson() async {
    final entries = await db.select(db.dailyEntries).get(),
        sessions = await db.select(db.cleanupSessions).get(),
        settings = await (db.select(
          db.appPreferences,
        )..where((t) => t.id.equals(1))).getSingleOrNull();
    return jsonEncode({
      'version': 1,
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'daily_entries': [
        for (final e in entries)
          {
            'date': e.dateKey,
            'count': e.count,
            'created_at': e.createdAt.toIso8601String(),
            'updated_at': e.updatedAt.toIso8601String(),
          },
      ],
      'cleanup_sessions': [
        for (final s in sessions)
          {
            'id': s.id,
            'started_at': s.startedAt.toIso8601String(),
            'ended_at': s.endedAt?.toIso8601String(),
            'count': s.count,
            'duration_seconds': s.durationSeconds,
            'distance_meters': s.distanceMeters,
            'location_mode': s.locationMode,
            'notes': s.notes,
          },
      ],
      'settings': settings == null
          ? null
          : {
              'theme_mode': settings.themeMode,
              'reduced_motion': settings.reducedMotion,
            },
    });
  }

  Future<void> importJson(String raw, ImportMergeMode mode) async {
    final value = jsonDecode(raw);
    if (value is! Map<String, dynamic> ||
        value['version'] != 1 ||
        value['daily_entries'] is! List) {
      throw const FormatException(
        'Invalid or unsupported ZigiQuest export format.',
      );
    }
    final parsed = <DailyEntriesCompanion>[];
    for (final item in value['daily_entries'] as List) {
      if (item is! Map ||
          item['date'] is! String ||
          item['count'] is! int ||
          (item['count'] as int) < 0 ||
          DateTime.tryParse(item['date'] as String) == null) {
        throw const FormatException('Invalid daily entry data.');
      }
      final now = DateTime.now();
      parsed.add(
        DailyEntriesCompanion.insert(
          id: const Uuid().v4(),
          dateKey: item['date'] as String,
          count: Value(item['count'] as int),
          createdAt: DateTime.tryParse('${item['created_at']}') ?? now,
          updatedAt: DateTime.tryParse('${item['updated_at']}') ?? now,
        ),
      );
    }
    await db.transaction(() async {
      if (mode == ImportMergeMode.replaceAll) {
        await db.delete(db.dailyEntries).go();
      }
      for (final row in parsed) {
        final existing = await (db.select(
          db.dailyEntries,
        )..where((t) => t.dateKey.equals(row.dateKey.value))).getSingleOrNull();
        if (existing != null && mode == ImportMergeMode.keepExisting) continue;
        if (existing != null) {
          await (db.update(
            db.dailyEntries,
          )..where((t) => t.dateKey.equals(row.dateKey.value))).write(
            DailyEntriesCompanion(count: row.count, updatedAt: row.updatedAt),
          );
        } else {
          await db.into(db.dailyEntries).insert(row);
        }
      }
    });
  }
}
