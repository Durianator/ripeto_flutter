import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ripeto_flutter/component.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
//Thanks to this website https://blog.logrocket.com/implementing-local-notifications-in-flutter/

class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'channel ID',
    'channel name',
    channelDescription: 'channel description',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  Future<void> showNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Notification Title',
      'This is the Notification Body',
      NotificationDetails(android: _androidNotificationDetails),
      payload: 'Notification Payload',
    );
  }

  Future<void> scheduleNotifications(
      int index, QueryDocumentSnapshot<Object> habitQuerySnapshot) async {
    String reminderTimeString = habitQuerySnapshot.get(reminderTimeKey);
    String frequencyString = habitQuerySnapshot.get(frequencyKey);
//TODO: Refactor this.
    TimeOfDay reminderTimeTimeOfDay =
        convertStringToTimeOfDay(reminderTimeString);

    List<String> frequency =
        convertFrequencyFirebaseDataToDayListString(frequencyString);

    List<int> dayListInt = convertFrequencyStringToDayListInt(frequencyString);

    DateTime now = DateTime.now();
    DateTime reminderTimeDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      reminderTimeTimeOfDay.hour,
      reminderTimeTimeOfDay.minute,
    );

    if (dayListInt.contains(now.weekday)) {
      if (reminderTimeDateTime.isBefore(DateTime.now())) {
        if (dayListInt.length == 1) {
          reminderTimeDateTime = reminderTimeDateTime.add(Duration(days: 7));
        } else {
          int nextNearestDayIndex = 0;
          for (int i = 0; i < dayListInt.length; i++) {
            int day = dayListInt[i];
            if (day == now.weekday) nextNearestDayIndex = i + 1;
          }
          reminderTimeDateTime =
              reminderTimeDateTime.next(dayListInt[nextNearestDayIndex]);
        }
      }
    } else {
      int nextNearestDayIndex = 0;
      for (int i = 0; i < dayListInt.length; i++) {
        int day = dayListInt[i];
        if (day - now.weekday > 0) {
          nextNearestDayIndex = i;
          if (dayListInt[i] < dayListInt[nextNearestDayIndex])
            nextNearestDayIndex = i;
        }
      }
      reminderTimeDateTime =
          reminderTimeDateTime.next(dayListInt[nextNearestDayIndex]);
    }

    print(reminderTimeDateTime);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        index,
        habitQuerySnapshot.get(habitNameKey) +
            ' after ' +
            habitQuerySnapshot.get(triggerEventKey),
        "Open Ripeto to check off the habit.",
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3)),
        tz.TZDateTime.from(reminderTimeDateTime, tz.local),
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        index,
        'Habit Name' + ' after ' + 'Trigger Event',
        "Open Ripeto to check off the habit.",
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3)),
        tz.TZDateTime.from(DateTime(2022, 1, 31, 14, 17, 0), tz.local),
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}

extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return this.add(
      Duration(
        days: (day - this.weekday) % DateTime.daysPerWeek,
      ),
    );
  }
}
