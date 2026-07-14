import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'active_session_store.dart';
import 'notification_service.dart';

class EngagementSettings {
  const EngagementSettings({
    required this.timeoutMinutes,
    required this.remindersEnabled,
  });
  final int timeoutMinutes;
  final bool remindersEnabled;
  Duration get timeout => Duration(minutes: timeoutMinutes);
}

class EngagementPreferences {
  EngagementPreferences({SharedPreferencesAsync? preferences})
    : _providedPreferences = preferences;
  static const _timeoutKey = 'zigiquest.session_timeout_minutes';
  static const _remindersKey = 'zigiquest.cleanup_reminders';
  static const _lastCompletionKey = 'zigiquest.last_cleanup_completion';
  final SharedPreferencesAsync? _providedPreferences;
  SharedPreferencesAsync? _preferences;
  final Map<String, Object> _memory = {};
  SharedPreferencesAsync? get _prefs {
    try {
      return _providedPreferences ??
          (_preferences ??= SharedPreferencesAsync());
    } catch (_) {
      return null;
    }
  }

  Future<int?> _int(String key) async {
    try {
      return await _prefs?.getInt(key) ?? _memory[key] as int?;
    } catch (_) {
      return _memory[key] as int?;
    }
  }

  Future<bool?> _bool(String key) async {
    try {
      return await _prefs?.getBool(key) ?? _memory[key] as bool?;
    } catch (_) {
      return _memory[key] as bool?;
    }
  }

  Future<String?> _string(String key) async {
    try {
      return await _prefs?.getString(key) ?? _memory[key] as String?;
    } catch (_) {
      return _memory[key] as String?;
    }
  }

  Future<void> _setInt(String key, int value) async {
    _memory[key] = value;
    try {
      await _prefs?.setInt(key, value);
    } catch (_) {}
  }

  Future<void> _setBool(String key, bool value) async {
    _memory[key] = value;
    try {
      await _prefs?.setBool(key, value);
    } catch (_) {}
  }

  Future<void> _setString(String key, String value) async {
    _memory[key] = value;
    try {
      await _prefs?.setString(key, value);
    } catch (_) {}
  }

  Future<EngagementSettings> load() async => EngagementSettings(
    timeoutMinutes: await _int(_timeoutKey) ?? 120,
    remindersEnabled: await _bool(_remindersKey) ?? false,
  );
  Future<void> setTimeoutMinutes(int minutes) => _setInt(_timeoutKey, minutes);
  Future<void> setRemindersEnabled(bool enabled) =>
      _setBool(_remindersKey, enabled);
  Future<void> recordCompletedCleanup() =>
      _setString(_lastCompletionKey, DateTime.now().toUtc().toIso8601String());
  Future<bool> hasBeenInactiveForMonth() async {
    final raw = await _string(_lastCompletionKey);
    final last = raw == null ? null : DateTime.tryParse(raw);
    return last == null ||
        DateTime.now().toUtc().difference(last.toUtc()) >=
            const Duration(days: 30);
  }
}

class ReminderCoordinator {
  ReminderCoordinator(
    this._preferences,
    this._activeStore,
    this._notifications,
  );
  final EngagementPreferences _preferences;
  final ActiveSessionStore _activeStore;
  final NotificationService _notifications;
  Future<bool> enable() async {
    if (!await _notifications.requestPermission()) return false;
    await _preferences.setRemindersEnabled(true);
    await refresh();
    return true;
  }

  Future<void> disable() async {
    await _preferences.setRemindersEnabled(false);
    await _notifications.cancelReminder();
  }

  Future<void> refresh() async {
    final settings = await _preferences.load();
    if (!settings.remindersEnabled || await _activeStore.load() != null) {
      await _notifications.cancelReminder();
      return;
    }
    await _notifications.scheduleReminder(
      inactive: await _preferences.hasBeenInactiveForMonth(),
    );
  }

  Future<void> cleanupCompleted() async {
    await _preferences.recordCompletedCleanup();
    await refresh();
  }
}

final engagementPreferencesProvider = Provider<EngagementPreferences>(
  (ref) => EngagementPreferences(),
);
final engagementSettingsProvider = FutureProvider<EngagementSettings>(
  (ref) => ref.watch(engagementPreferencesProvider).load(),
);
final reminderCoordinatorProvider = Provider<ReminderCoordinator>(
  (ref) => ReminderCoordinator(
    ref.watch(engagementPreferencesProvider),
    ref.watch(activeSessionStoreProvider),
    NotificationService.instance,
  ),
);
