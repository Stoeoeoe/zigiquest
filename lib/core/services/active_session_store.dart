import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

const sessionInactivityReminderTask = 'zigiquest.session-inactivity-reminder';
const sessionInactivityReminderUniqueName =
    'zigiquest.session-inactivity-reminder-once';
const sessionFinalizationTask = 'zigiquest.session-finalization';
const sessionFinalizationUniqueName = 'zigiquest.session-finalization-once';

const sessionInactivityReminderDelay = Duration(hours: 1);
const sessionInactivityPromptDelay = Duration(hours: 2);
const sessionInactivityFinalizationDelay = Duration(hours: 4);

class ActiveCleanupSession {
  const ActiveCleanupSession({
    required this.id,
    required this.startedAt,
    required this.expiresAt,
    required this.tracking,
    required this.count,
    this.lastInteractionAt,
  });

  final String id;
  final DateTime startedAt;

  /// The silent finalization deadline. It moves forward with each interaction.
  final DateTime expiresAt;
  final String tracking;
  final int count;
  final DateTime? lastInteractionAt;

  DateTime get lastInteraction => lastInteractionAt ?? startedAt;
  bool get isExpired => !DateTime.now().toUtc().isBefore(expiresAt);
  bool get isReminderDue => DateTime.now()
      .toUtc()
      .difference(lastInteraction) >= sessionInactivityReminderDelay;
  bool get isInactivityPromptDue => DateTime.now()
      .toUtc()
      .difference(lastInteraction) >= sessionInactivityPromptDelay;

  ActiveCleanupSession copyWith({
    int? count,
    DateTime? lastInteractionAt,
    DateTime? expiresAt,
  }) => ActiveCleanupSession(
    id: id,
    startedAt: startedAt,
    expiresAt: expiresAt ?? this.expiresAt,
    tracking: tracking,
    count: count ?? this.count,
    lastInteractionAt: lastInteractionAt ?? this.lastInteractionAt,
  );

  ActiveCleanupSession interacted({int? count, DateTime? at}) {
    final interaction = (at ?? DateTime.now()).toUtc();
    return copyWith(
      count: count,
      lastInteractionAt: interaction,
      expiresAt: interaction.add(sessionInactivityFinalizationDelay),
    );
  }

  Map<String, Object> toJson() => {
    'id': id,
    'started_at': startedAt.toUtc().toIso8601String(),
    'expires_at': expiresAt.toUtc().toIso8601String(),
    'last_interaction_at': lastInteraction.toUtc().toIso8601String(),
    'tracking': tracking,
    'count': count,
  };

  static ActiveCleanupSession? fromJson(String? raw) {
    if (raw == null) return null;
    try {
      final value = jsonDecode(raw) as Map<String, dynamic>;
      final startedAt = DateTime.parse(value['started_at'] as String).toUtc();
      final lastRaw = value['last_interaction_at'] as String?;
      final lastInteractionAt = lastRaw == null
          ? startedAt
          : DateTime.parse(lastRaw).toUtc();

      // Older sessions had a two-hour hard expiry. Upgrade them to the new
      // four-hour inactivity window when they are restored.
      final expiresAt = lastRaw == null
          ? lastInteractionAt.add(sessionInactivityFinalizationDelay)
          : DateTime.parse(value['expires_at'] as String).toUtc();

      return ActiveCleanupSession(
        id: value['id'] as String,
        startedAt: startedAt,
        expiresAt: expiresAt,
        lastInteractionAt: lastInteractionAt,
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

  Future<ActiveCleanupSession> create({required String tracking}) async {
    final startedAt = DateTime.now().toUtc();
    final session = ActiveCleanupSession(
      id: const Uuid().v4(),
      startedAt: startedAt,
      expiresAt: startedAt.add(sessionInactivityFinalizationDelay),
      lastInteractionAt: startedAt,
      tracking: tracking,
      count: 0,
    );
    await saveWithInactivitySchedule(session);
    return session;
  }

  Future<void> save(ActiveCleanupSession session) =>
      _write(jsonEncode(session.toJson()));

  Future<void> saveWithInactivitySchedule(ActiveCleanupSession session) async {
    await save(session);
    unawaited(_scheduleInactivityReminder(session));
    unawaited(scheduleFinalization(session));
  }

  Future<void> scheduleFinalization(ActiveCleanupSession session) async {
    try {
      await Workmanager().registerOneOffTask(
        sessionFinalizationUniqueName,
        sessionFinalizationTask,
        initialDelay: _remainingUntil(session.expiresAt),
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );
    } catch (_) {}
  }

  Future<void> _scheduleInactivityReminder(ActiveCleanupSession session) async {
    try {
      await Workmanager().registerOneOffTask(
        sessionInactivityReminderUniqueName,
        sessionInactivityReminderTask,
        initialDelay: _remainingUntil(
          session.lastInteraction.add(sessionInactivityReminderDelay),
        ),
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );
    } catch (_) {}
  }

  Duration _remainingUntil(DateTime target) {
    final remaining = target.difference(DateTime.now().toUtc());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  Future<void> clear() async {
    await _remove();
    unawaited(_cancelInactivityTasks());
  }

  Future<void> _cancelInactivityTasks() async {
    try {
      await Workmanager().cancelByUniqueName(sessionInactivityReminderUniqueName);
      await Workmanager().cancelByUniqueName(sessionFinalizationUniqueName);
    } catch (_) {}
  }
}

final activeSessionStoreProvider = Provider<ActiveSessionStore>(
  (ref) => ActiveSessionStore(),
);
final activeSessionProvider = FutureProvider<ActiveCleanupSession?>(
  (ref) => ref.watch(activeSessionStoreProvider).load(),
);
