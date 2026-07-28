import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'app/splash_screen.dart';
import 'core/database/app_database.dart';
import 'core/services/supabase_bootstrap.dart';
import 'core/services/background_sync.dart';
import 'core/services/active_session_store.dart';
import 'core/services/notification_service.dart';
import 'core/services/session_persistence.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _BootstrapApp());
}

class _BootstrapApp extends StatefulWidget {
  const _BootstrapApp();

  @override
  State<_BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<_BootstrapApp> {
  late final Future<void> _startup = _initializeWithMinimumSplash();
  AppDatabase? _database;

  Future<void> _initializeWithMinimumSplash() async {
    await Future.wait([
      _initialize(),
      Future<void>.delayed(const Duration(milliseconds: 1300)),
    ]);
  }

  Future<void> _initialize() async {
    await initializeDateFormatting('de_CH');
    await initializeBackgroundSync();
    await initializeNotifications();
    await initializeSupabase();

    final database = _database = AppDatabase.open();
    await database.normalizeLegacyLocationModes();
    final active = await ActiveSessionStore().load();
    if (active != null && active.isExpired) {
      await SessionPersistence(
        database,
      ).finalizeActive(active, endedAt: active.expiresAt);
      await ActiveSessionStore().clear();
      await NotificationService.instance.showSessionExpired();
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: _startup,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done ||
          _database == null) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ZigiSplashScreen(),
        );
      }
      return ProviderScope(
        overrides: [databaseProvider.overrideWithValue(_database!)],
        child: const ZigiQuestApp(),
      );
    },
  );
}
