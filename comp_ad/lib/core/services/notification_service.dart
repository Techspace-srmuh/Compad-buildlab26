import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/timetable/models/timetable_slot_model.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._init();
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  NotificationService._init();

  static const String keyNotificationsEnabled = 'compad_class_notifications_enabled';
  static const String keyLeadMinutes = 'compad_notification_lead_minutes';

  Future<bool> isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyNotificationsEnabled) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyNotificationsEnabled, enabled);
    if (!enabled) {
      await cancelAll();
    }
  }

  Future<void> init() async {
    if (_initialized) return;

    try {
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidInit);

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          debugPrint('Notification clicked: ${response.payload}');
        },
      );

      if (Platform.isAndroid) {
        const channel = AndroidNotificationChannel(
          'compad_class_alerts',
          'CompAd Class Alerts',
          description: 'Timetable class reminders and schedule alerts',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        );

        await _notifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
      }

      _initialized = true;
    } catch (e) {
      debugPrint('Notification init warning: $e');
    }
  }

  Future<bool> requestPermissions() async {
    await init();
    try {
      if (Platform.isAndroid) {
        final android = _notifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        final granted = await android?.requestNotificationsPermission();
        return granted ?? true;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> sendTestNotification() async {
    await init();
    await requestPermissions();

    const androidDetails = AndroidNotificationDetails(
      'compad_class_alerts',
      'CompAd Class Alerts',
      channelDescription: 'Timetable class reminders and schedule alerts',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      9001,
      'CompAd Class Reminder Test',
      'Timetable alerts are active! You will receive class reminders ahead of time.',
      details,
    );
  }

  /// Evaluates weekly timetable slots and schedules alerts
  Future<void> syncTimetableReminders(List<TimetableSlotModel> slots) async {
    await init();
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool(keyNotificationsEnabled) ?? true;

    if (!isEnabled || slots.isEmpty) {
      return;
    }

    final leadMinutes = prefs.getInt(keyLeadMinutes) ?? 10;
    final now = DateTime.now();

    // Check today's slots and upcoming classes
    for (int i = 0; i < slots.length; i++) {
      final slot = slots[i];
      if (slot.dayOfWeek == now.weekday) {
        final timeParts = slot.startTime.split(':');
        if (timeParts.length == 2) {
          final h = int.tryParse(timeParts[0]) ?? 9;
          final m = int.tryParse(timeParts[1]) ?? 0;
          final classTime = DateTime(now.year, now.month, now.day, h, m);
          final reminderTime = classTime.subtract(Duration(minutes: leadMinutes));

          // If the class is today and reminder time is within the next 4 hours
          if (reminderTime.isAfter(now) && reminderTime.difference(now).inHours <= 4) {
            final diff = classTime.difference(now).inMinutes;
            const androidDetails = AndroidNotificationDetails(
              'compad_class_alerts',
              'CompAd Class Alerts',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            );
            await _notifications.show(
              2000 + i,
              'Upcoming Class: ${slot.course?.code ?? "Lecture"}',
              '${slot.course?.name ?? "Class"} starts in $diff mins at ${slot.startTime} in ${slot.room}',
              const NotificationDetails(android: androidDetails),
            );
          }
        }
      }
    }
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
