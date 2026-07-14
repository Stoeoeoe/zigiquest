import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zigi_quest/core/database/app_database.dart';

void main() {
  test('session photo metadata persists locally with upload pending', () async {
    final database = AppDatabase.memory();
    final now = DateTime(2026, 7, 12);
    await database
        .into(database.cleanupSessions)
        .insert(
          CleanupSessionsCompanion.insert(
            id: 'session',
            startedAt: now,
            count: const Value(3),
            locationMode: const Value('none'),
            updatedAt: now,
          ),
        );
    await database
        .into(database.sessionPhotos)
        .insert(
          SessionPhotosCompanion.insert(
            id: 'photo',
            sessionId: 'session',
            path: '/private/photo.jpg',
            type: 'after',
            width: 800,
            height: 600,
            sizeBytes: 1024,
            createdAt: now,
          ),
        );
    final photo = await (database.select(
      database.sessionPhotos,
    )..where((item) => item.id.equals('photo'))).getSingle();
    expect(photo.uploaded, isFalse);
    expect(photo.sizeBytes, 1024);
    await database.close();
  });
}
