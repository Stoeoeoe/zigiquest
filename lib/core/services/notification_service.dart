import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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

  NotificationDetails get _details => const NotificationDetails(
    android: AndroidNotificationDetails(
      'zigiquest_gentle_reminders',
      'Sanfte Erinnerungen',
      channelDescription:
          'Optionale Cleanup-Erinnerungen und Session-Hinweise.',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    ),
    iOS: DarwinNotificationDetails(),
  );
  Future<void> scheduleReminder({required bool inactive}) async {
    await initialize();
    if (!_available) return;
    try {
      await _plugin.zonedSchedule(
        id: reminderId,
        title: 'Zeit f\u00fcr eine kleine Runde?',
        body: inactive
            ? 'Wenn du magst: Ein kurzer Cleanup macht einen sichtbaren Unterschied.'
            : 'Lust auf einen kleinen Cleanup-Spaziergang? Ganz ohne Druck.',
        scheduledDate: tz.TZDateTime.now(
          tz.local,
        ).add(inactive ? const Duration(days: 30) : const Duration(days: 7)),
        notificationDetails: _details,
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

  Future<void> showSessionExpired() async {
    await initialize();
    if (!_available) return;
    try {
      await _plugin.show(
        id: 4102,
        title: 'Cleanup-Session beendet',
        body:
            'Deine offene Session wurde nach der eingestellten Zeit sicher abgeschlossen.',
        notificationDetails: _details,
        payload: 'session-expired',
      );
    } catch (_) {}
  }
}

Future<void> initializeNotifications() =>
    NotificationService.instance.initialize();
