import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class ReminderService {
  static final instance = ReminderService();
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> _initialize() async {
    if (!supported) return;
    if (!_ready) {
      tzdata.initializeTimeZones();
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/launcher_icon'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestSoundPermission: false,
            requestBadgePermission: false,
          ),
        ),
      );
      _ready = true;
    }
  }

  Future<bool> enable() async {
    if (!supported) return false;
    await _initialize();
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission() ??
          false;
    }
    return await _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, sound: true, badge: true) ??
        false;
  }

  Future<void> schedule(
    int id,
    String title,
    DateTime date, {
    bool daily = false,
  }) async {
    if (!await enable()) {
      throw StateError(
        'फोन की Settings में notifications अनुमति दें। Mobile app पर reminders उपलब्ध हैं।',
      );
    }
    // Interpret picker values in the device's current UTC offset, without a location permission.
    final scheduled = tz.TZDateTime.from(date.toUtc(), tz.UTC);
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: 'Kisan Daily खोलकर आज का काम देखें।',
      scheduledDate: scheduled,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'farmer_reminders',
          'खेती के रिमाइंडर',
          channelDescription: 'Daily bulletin, crop tasks and scheme reminders',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: daily ? DateTimeComponents.time : null,
    );
  }

  Future<void> cancel(int id) async {
    if (supported) {
      if (!_ready) await _initialize();
      await _plugin.cancel(id: id);
    }
  }
}
