import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initNotifications();
  }

  void _initNotifications() {
    tz.initializeTimeZones();
  }

  Future<bool?> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestExactAlarmsPermission();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      return await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
    } else if (Platform.isIOS) {
      return await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    return null;
  }

  Future<void> showNotification({required String title}) async {
    var androidDetails = const AndroidNotificationDetails(
      'channelId',
      'Daily Reminder',
      importance: Importance.high,
      priority: Priority.high,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Expense Deleted',
      'Expense "$title" was deleted.',
      NotificationDetails(android: androidDetails),
    );
  }

  Future<void> initializeNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleDailyReminder() async {
    var androidDetails = const AndroidNotificationDetails(
      'channelId',
      'Daily Reminder',
      importance: Importance.high,
      priority: Priority.high,
    );

    var generalNotificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Daily Reminder', // Notification title
      'Don\'t forget to complete your daily tasks!', // Notification body
      _dailyNotificationTime(), // Time to show the notification
      generalNotificationDetails,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _dailyNotificationTime() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    return now.add(const Duration(minutes: 1));
  }
}
