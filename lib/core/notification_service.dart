import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:adhan/adhan.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz_data.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> schedulePrayerNotifications(PrayerTimes prayerTimes) async {
    await _notificationsPlugin.cancelAll();

    final prayers = {
      'الفجر': prayerTimes.fajr,
      'الظهر': prayerTimes.dhuhr,
      'العصر': prayerTimes.asr,
      'المغرب': prayerTimes.maghrib,
      'العشاء': prayerTimes.isha,
    };

    int id = 0;
    prayers.forEach((name, time) async {
      if (time.isAfter(DateTime.now())) {
        await _notificationsPlugin.zonedSchedule(
          id++,
          'حان الآن وقت صلاة $name',
          'الصلاة خير من النوم، أقم صلاتك يرحمك الله',
          tz.TZDateTime.from(time, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'prayer_channel', 'مواقيت الصلاة',
              channelDescription: 'تنبيهات مواقيت الصلاة',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    });
  }
}
