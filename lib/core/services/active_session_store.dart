import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

const sessionExpiryTask = 'zigiquest.session-expiry';
const sessionExpiryUniqueName = 'zigiquest.session-expiry-once';

class ActiveCleanupSession {
  const ActiveCleanupSession({
    required this.id,
    required this.startedAt,
    required this.expiresAt,
    required this.tracking,
    required this.count,
  });
  final String id;
  final DateTime startedAt;
  final DateTime expiresAt;
  final String tracking;
  final int count;
  bool get isExpired => !DateTime.now().toUtc().isBefore(expiresAt);
  ActiveCleanupSession copyWith({int? count}) => ActiveCleanupSession(
    id: id,
    startedAt: startedAt,
    expiresAt: expiresAt,
    tracking: tracking,
    count: count ?? this.count,
  );
  Map<String, Object> toJson() => {
    'id': id,
    'started_at': startedAt.toUtc().toIso8601String(),
    'expires_at': expiresAt.toUtc().toIso8601String(),
    'tracking': tracking,
    'count': count,
  };
  static ActiveCleanupSession? fromJson(String? raw) {
    if (raw == null) return null;
    try {
      final value = jsonDecode(raw) as Map<String, dynamic>;
      return ActiveCleanupSession(
        id: value['id'] as String,
        startedAt: DateTime.parse(value['started_at'] as String).toUtc(),
        expiresAt: DateTime.parse(value['expires_at'] as String).toUtc(),
        tracking: value['tracking'] as String? ?? 'none',
        count: (value['count'] as num?)?.toInt() ?? 0,
      );
    } catch (_) {
      return null;
    }
  }
}

class ActiveSessionStore {
  ActiveSessionStore({SharedPreferencesAsync? preferences})
    : _providedPreferences = preferences;
  static const _key = 'zigiquest.active_cleanup_session';
  final SharedPreferencesAsync? _providedPreferences;
  SharedPreferencesAsync? _preferences;
  String? _memory;
  SharedPreferencesAsync? get _prefs {
    try {
      return _providedPreferences ??
          (_preferences ??= SharedPreferencesAsync());
    } catch (_) {
      return null;
    }
  }

  Future<String?> _read() async {
    try {
      return await _prefs?.getString(_key) ?? _memory;
    } catch (_) {
      return _memory;
    }
  }

  Future<void> _write(String value) async {
    _memory = value;
    try {
      await _prefs?.setString(_key, value);
    } catch (_) {}
  }

  Future<void> _remove() async {
    _memory = null;
    try {
      await _prefs?.remove(_key);
    } catch (_) {}
  }

  Future<ActiveCleanupSession?> load() async =>
      ActiveCleanupSession.fromJson(await _read());
  Future<ActiveCleanupSession> create({
    required String tracking,
    required Duration timeout,
  }) async {
    final startedAt = DateTime.now().toUtc();
    final session = ActiveCleanupSession(
      id: const Uuid().v4(),
      startedAt: startedAt,
      expiresAt: startedAt.add(timeout),
      tracking: tracking,
      count: 0,
    );
    await save(session);
    unawaited(_scheduleExpiry(timeout));
    return session;
  }

  Future<void> save(ActiveCleanupSession session) =>
      _write(jsonEncode(session.toJson()));
  Future<void> _scheduleExpiry(Duration timeout) async {
    try {
      await Workmanager().registerOneOffTask(
        sessionExpiryUniqueName,
        sessionExpiryTask,
        initialDelay: timeout,
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );
    } catch (_) {}
  }

  Future<void> clear() async {
    await _remove();
    unawaited(_cancelExpiry());
  }

  Future<void> _cancelExpiry() async {
    try {
      await Workmanager().cancelByUniqueName(sessionExpiryUniqueName);
    } catch (_) {}
  }
}

final activeSessionStoreProvider = Provider<ActiveSessionStore>(
  (ref) => ActiveSessionStore(),
);
final activeSessionProvider = FutureProvider<ActiveCleanupSession?>(
  (ref) => ref.watch(activeSessionStoreProvider).load(),
);
