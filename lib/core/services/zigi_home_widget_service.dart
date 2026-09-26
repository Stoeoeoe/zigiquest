import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';

import '../database/app_database.dart';
import 'active_session_store.dart';
import 'collection_repository.dart';
import 'session_persistence.dart';

const _providerName = 'ZigiQuickAddWidgetProvider';
const _countKey = 'zigi_widget_count';
const _cleanupKey = 'zigi_widget_cleanup_active';

/// Keeps the Android home-screen widget aligned with the current target.
///
/// An unfinished cleanup always takes precedence over the daily counter.
class ZigiHomeWidgetService {
  const ZigiHomeWidgetService._();

  static Future<void> refresh(AppDatabase database) async {
    final active = await ActiveSessionStore().load();
    final isCleanupActive = active != null && !active.isExpired;
    final count = isCleanupActive
        ? active.count
        : await database.countFor(dayKey());

    await Future.wait([
      HomeWidget.saveWidgetData<int>(_countKey, count),
      HomeWidget.saveWidgetData<bool>(_cleanupKey, isCleanupActive),
    ]);
    await HomeWidget.updateWidget(androidName: _providerName);
  }

  static Future<void> addOne(AppDatabase database) async {
    final store = ActiveSessionStore();
    final active = await store.load();
    if (active != null && !active.isExpired) {
      await store.saveWithInactivitySchedule(
        active.interacted(count: active.count + 1),
      );
    } else {
      if (active != null) {
        await SessionPersistence(
          database,
        ).finalizeActive(active, endedAt: active.expiresAt);
        await store.clear();
      }
      await CollectionRepository(database).change(DateTime.now(), 1);
    }
    await refresh(database);
  }
}

/// Entry point invoked directly by the Android widget's + button.
@pragma('vm:entry-point')
Future<void> zigiHomeWidgetInteractivityCallback(Uri? uri) async {
  if (uri?.scheme != 'zigiquest' ||
      uri?.host != 'widget' ||
      uri?.path != '/add') {
    return;
  }

  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase.open();
  try {
    await ZigiHomeWidgetService.addOne(database);
  } finally {
    await database.close();
  }
}