import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import '../database/app_database.dart';
import 'active_session_store.dart';
import 'notification_service.dart';
import 'session_persistence.dart';
import 'supabase_bootstrap.dart';
import 'sync_service.dart';

const backgroundSyncTask = 'zigiquest.sync-outbox';
const backgroundSyncUniqueName = 'zigiquest.periodic-sync';

@pragma('vm:entry-point')
void backgroundSyncDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeSupabase();
    final database = AppDatabase.open();
    try {
      if (task == sessionInactivityReminderTask) {
        final store = ActiveSessionStore();
        final active = await store.load();
        if (active != null) {
          if (active.isExpired) {
            await SessionPersistence(
              database,
            ).finalizeActive(active, endedAt: active.expiresAt);
            await store.clear();
          } else if (active.isReminderDue) {
            await initializeNotifications();
            await NotificationService.instance.showSessionInactivityReminder();
            await store.scheduleFinalization(active);
          }
        }
      } else if (task == sessionFinalizationTask) {
        final store = ActiveSessionStore();
        final active = await store.load();
        if (active != null && active.isExpired) {
          await SessionPersistence(
            database,
          ).finalizeActive(active, endedAt: active.expiresAt);
          await store.clear();
        }
      } else {
        await SyncService(database, configuredSupabase()).flush();
      }
      return true;
    } catch (_) {
      return false;
    } finally {
      await database.close();
    }
  });
}

Future<void> initializeBackgroundSync() async {
  await Workmanager().initialize(backgroundSyncDispatcher);
  await Workmanager().registerPeriodicTask(
    backgroundSyncUniqueName,
    backgroundSyncTask,
    frequency: const Duration(hours: 24),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}
