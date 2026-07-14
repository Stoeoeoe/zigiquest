import 'package:flutter_test/flutter_test.dart';
import 'package:zigi_quest/core/database/app_database.dart';
import 'package:zigi_quest/core/services/active_session_store.dart';
import 'package:zigi_quest/core/services/collection_repository.dart';
import 'package:zigi_quest/core/services/session_persistence.dart';

void main() {
  test('active session state round-trips and knows its expiry', () {
    final active = ActiveCleanupSession(
      id: 'session-1',
      startedAt: DateTime.utc(2026, 7, 13, 10),
      expiresAt: DateTime.utc(2026, 7, 13, 12),
      tracking: 'none',
      count: 7,
    );
    final restored = ActiveCleanupSession.fromJson(active.toJson().toString());
    expect(restored, isNull, reason: 'A raw Map string is not persisted JSON.');
    final json =
        '{"id":"session-1","started_at":"2026-07-13T10:00:00.000Z","expires_at":"2026-07-13T12:00:00.000Z","tracking":"none","count":7}';
    final decoded = ActiveCleanupSession.fromJson(json);
    expect(decoded?.id, 'session-1');
    expect(decoded?.count, 7);
  });

  test(
    'expired session finalization preserves its count exactly once',
    () async {
      final database = AppDatabase.memory();
      final active = ActiveCleanupSession(
        id: 'expired-1',
        startedAt: DateTime.utc(2026, 7, 13, 10),
        expiresAt: DateTime.utc(2026, 7, 13, 12),
        tracking: 'none',
        count: 9,
      );
      final persistence = SessionPersistence(database);
      await persistence.finalizeActive(active, endedAt: active.expiresAt);
      await persistence.finalizeActive(active, endedAt: active.expiresAt);
      expect(await database.countFor(dayKey(active.expiresAt.toLocal())), 9);
      expect(
        (await database.select(database.cleanupSessions).get()),
        hasLength(1),
      );
      await database.close();
    },
  );
}
