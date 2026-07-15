import 'package:drift/drift.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zigi_quest/core/database/app_database.dart';
import 'package:zigi_quest/features/screens.dart';
import 'package:zigi_quest/features/visualization/zigi_pile.dart';
import 'package:zigi_quest/features/visualization/zigi_sprite_data.dart';

void main() {
  test('all sprite colliders use a safe convex vertex budget', () {
    expect(zigiSpriteData, hasLength(11));
    for (final sprite in zigiSpriteData) {
      expect(sprite.collider.length, inInclusiveRange(3, 8));
      expect(sprite.renderWidth, greaterThan(0));
      expect(sprite.renderHeight, greaterThan(0));
    }
  });
  testWidgets('pile keeps the same Forge2D game when the count changes', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SizedBox(height: 300, child: _PileHarness())),
      ),
    );
    await tester.pump();
    final finder = find.byWidgetPredicate((widget) => widget is GameWidget);
    final firstGame = (tester.widget(finder) as GameWidget).game;
    await tester.tap(find.byKey(const Key('increment-pile')));
    await tester.pump();
    final secondGame = (tester.widget(finder) as GameWidget).game;
    expect(identical(firstGame, secondGame), isTrue);
    expect(find.text('1 IM GLAS'), findsOneWidget);
  });

  testWidgets(
    'session clock starts after tracking choice and empty session earns no XP',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await initializeDateFormatting('de_CH');
      final database = AppDatabase.memory();
      await database
          .into(database.appPreferences)
          .insert(
            const AppPreferencesCompanion(
              id: Value(1),
              reducedMotion: Value(true),
            ),
          );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(database)],
          child: const MaterialApp(home: LiveSessionScreen()),
        ),
      );
      await tester.pump();
      expect(find.text('Cleanup-Runde starten'), findsOneWidget);
      await tester.tap(find.text('Runde ohne Standort starten'));
      await tester.pumpAndSettle();
      expect(find.text('CLEANUP LÄUFT'), findsOneWidget);
      expect(find.text('Ohne Tracking'), findsWidgets);
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 1100)),
      );
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('00:01'), findsOneWidget);
      await tester.tap(find.text('SESSION ABSCHLIESSEN'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cleanup speichern'));
      await tester.pumpAndSettle();
      expect(find.text('Keine XP'), findsOneWidget);
      await database.close();
    },
  );
}

class _PileHarness extends StatefulWidget {
  const _PileHarness();
  @override
  State<_PileHarness> createState() => _PileHarnessState();
}

class _PileHarnessState extends State<_PileHarness> {
  int count = 0;
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      ZigiPileView(count: count, reducedMotion: false),
      Positioned(
        right: 0,
        child: IconButton(
          key: const Key('increment-pile'),
          onPressed: () => setState(() => count++),
          icon: const Icon(Icons.add),
        ),
      ),
    ],
  );
}
