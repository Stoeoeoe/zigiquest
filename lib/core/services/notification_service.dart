import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../l10n/app_localizations.dart';

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();
  static const reminderId = 4101;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;
  bool _available = true;

  Future<void> initialize() async {
    if (_ready) return;
    tz.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } catch (_) {}
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('ic_stat_zigiquest'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
      );
    } catch (_) {
      _available = false;
    }
    _ready = true;
  }

  Future<bool> requestPermission() async {
    await initialize();
    if (!_available) return false;
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final granted = await android?.requestNotificationsPermission();
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final iosGranted = await ios?.requestPermissions(
        alert: true,
        badge: false,
        sound: true,
      );
      return granted ?? iosGranted ?? true;
    } catch (_) {
      return false;
    }
  }

  Future<NotificationDetails> _details() async {
    // In background tasks, we manually load the delegate if context isn't available.
    final l10n = await AppLocalizations.delegate.load(const Locale('de'));
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'zigiquest_gentle_reminders',
        l10n.notificationChannelName,
        channelDescription: l10n.notificationChannelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  Future<void> scheduleReminder({required bool inactive}) async {
    await initialize();
    if (!_available) return;
    final l10n = await AppLocalizations.delegate.load(const Locale('de'));
    try {
      await _plugin.zonedSchedule(
        id: reminderId,
        title: l10n.notificationReminderTitle,
        body: inactive
            ? l10n.notificationReminderBodyInactive
            : l10n.notificationReminderBodyActive,
        scheduledDate: tz.TZDateTime.now(
          tz.local,
        ).add(inactive ? const Duration(days: 30) : const Duration(days: 7)),
        notificationDetails: await _details(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'cleanup-reminder',
      );
    } catch (_) {}
  }

  Future<void> cancelReminder() async {
    await initialize();
    if (!_available) return;
    try {
      await _plugin.cancel(id: reminderId);
    } catch (_) {}
  }

  Future<void> showSessionInactivityReminder() async {
    await initialize();
    if (!_available) return;
    final l10n = await AppLocalizations.delegate.load(const Locale('de'));
    try {
      await _plugin.show(
        id: 4103,
        title: 'Noch am Sammeln?',
        body: 'Dein Cleanup ist noch offen. Tippe hier, um ihn fortzusetzen.',
        notificationDetails: await _details(),
        payload: 'active-cleanup',
      );
    } catch (_) {}
  }
  Future<void> showSessionExpired() async {
    await initialize();
    if (!_available) return;
    final l10n = await AppLocalizations.delegate.load(const Locale('de'));
    try {
      await _plugin.show(
        id: 4102,
        title: l10n.notificationExpiredTitle,
        body: l10n.notificationExpiredBody,
        notificationDetails: await _details(),
        payload: 'session-expired',
      );
    } catch (_) {}
  }
}

Future<void> initializeNotifications() =>
    NotificationService.instance.initialize();
