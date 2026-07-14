part of 'screens.dart';

final entriesProvider = StreamProvider<List<DailyEntry>>(
  (ref) => ref.watch(databaseProvider).watchDays(),
);
final sessionsProvider = StreamProvider<List<CleanupSession>>(
  (ref) =>
      (ref
              .watch(databaseProvider)
              .select(ref.watch(databaseProvider).cleanupSessions)
            ..where((row) => row.deletedAt.isNull())
            ..orderBy([(row) => OrderingTerm.desc(row.startedAt)]))
          .watch(),
);
final repositoryProvider = Provider<CollectionRepository>(
  (ref) => CollectionRepository(
    ref.watch(databaseProvider),
    onLocalWrite: () => ref.read(syncCoordinatorProvider).flush(),
  ),
);

int weekTotal(List<DailyEntry> rows) {
  final now = DateTime.now();
  final monday = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(Duration(days: now.weekday - 1));
  return rows
      .where((row) {
        final date = DateTime.tryParse(row.dateKey);
        return date != null && !date.isBefore(monday);
      })
      .fold(0, (sum, row) => sum + row.count);
}

int completedSessions(List<CleanupSession> sessions) =>
    sessions.where((session) => session.endedAt != null).length;
int collectionStreak(List<DailyEntry> rows) {
  final counts = {for (final row in rows) row.dateKey: row.count};
  var day = DateTime.now();
  var streak = 0;
  while ((counts[dayKey(day)] ?? 0) > 0) {
    streak++;
    day = day.subtract(const Duration(days: 1));
  }
  return streak;
}
