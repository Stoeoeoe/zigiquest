import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zigi_quest/app/app.dart';
import 'package:zigi_quest/core/database/app_database.dart';
import 'package:zigi_quest/core/services/auth_service.dart';

void main() {
  testWidgets('Today zero state and increment stay exact', (tester) async {
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
        overrides: [
          databaseProvider.overrideWithValue(database),
          guestModeProvider.overrideWith((ref) => Future.value(true)),
          onboardingCompletedProvider.overrideWith((ref) => Future.value(true)),
        ],
        child: const ZigiQuestApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('0'), findsWidgets);
    expect(find.text('Sammle. Zähle. Räume auf.'), findsNothing);
    final addButton = find.byIcon(Icons.add_rounded).first;
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pumpAndSettle();
    expect(
      await database.countFor(
        DateTime.now().toIso8601String().substring(0, 10),
      ),
      1,
    );
    await database.close();
  });
}
