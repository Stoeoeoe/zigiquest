import 'package:flutter_test/flutter_test.dart';
import 'package:zigi_quest/core/database/app_database.dart';
import 'package:zigi_quest/core/services/collection_repository.dart';
import 'package:zigi_quest/core/services/data_port.dart';
import 'package:zigi_quest/core/services/location_service.dart';
import 'package:zigi_quest/core/services/progression.dart';
import 'package:zigi_quest/core/services/achievements.dart';

void main() {
  group('offline domain', () {
    late AppDatabase db;
    late CollectionRepository repository;
    setUp(() {
      db = AppDatabase.memory();
      repository = CollectionRepository(db);
    });
    tearDown(() => db.close());
    test('count never goes negative and rapid increments are exact', () async {
      await repository.change(DateTime(2026, 7, 12), -1);
      expect(await db.countFor('2026-07-12'), 0);
      await Future.wait(
        List.generate(20, (_) => repository.change(DateTime(2026, 7, 12), 1)),
      );
      expect(await db.countFor('2026-07-12'), 20);
      final outbox = await db.select(db.syncOutbox).get();
      expect(outbox, isNotEmpty);
    });
    test('json validates and merge modes work', () async {
      final port = DataPort(db);
      await port.importJson(
        '{"version":1,"daily_entries":[{"date":"2026-07-12","count":7}]}',
        ImportMergeMode.importedValuesWin,
      );
      expect(await db.countFor('2026-07-12'), 7);
      final exported = await port.exportJson();
      expect(exported, contains('daily_entries'));
      expect(
        () => port.importJson('{"version":2}', ImportMergeMode.keepExisting),
        throwsFormatException,
      );
    });
  });
  group('progression', () {
    final service = ProgressionService();
    test('levels and milestones use stable thresholds', () {
      expect(service.levelFor(0), 1);
      expect(service.levelFor(250), 3);
      expect(service.milestones(9, 51), [10, 25, 50]);
    });
    test('quests complete at target', () {
      expect(questsFor(10, 10, 0).first.complete, isTrue);
    });
    test('achievements reflect their current progress', () {
      final progress = achievementsFor(
        total: 10,
        streak: 3,
        sessions: 0,
        week: 10,
      );
      expect(progress.first.unlocked, isTrue);
      expect(progress.where((item) => item.unlocked).length, 3);
      expect(progress.last.shownValue, 10);
    });
  });
  group('location privacy', () {
    final service = LocationService();
    test('coordinates are approximate', () {
      expect(service.approximate(47.376886), 47.377);
    });
    test('routes are simplified and capped', () {
      final points = List.generate(
        2000,
        (i) => RoutePoint(47 + i / 100000, 8 + i / 100000),
      );
      expect(service.simplify(points, cap: 100).length, lessThanOrEqualTo(101));
    });
  });
}
