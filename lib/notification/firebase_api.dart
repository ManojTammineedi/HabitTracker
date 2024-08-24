// import 'package:timezone/timezone.dart' as tz;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class FireBaseApi {
//   static final _notifications = FlutterLocalNotificationsPlugin();

//   Future<void> initNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );

//     await _notifications.initialize(initializationSettings);
//   }

//   // Function to show notifications
//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'habit_reminders',
//       'Habit Reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await _notifications.show(
//       id,
//       title,
//       body,
//       platformChannelSpecifics,
//     );
//   }

//   // Function to schedule notifications
//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//   }) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'habit_reminders',
//       'Habit Reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     // Convert DateTime to TZDateTime
//     final tz.TZDateTime tzScheduledDate =
//         tz.TZDateTime.from(scheduledDate, tz.local);

//     await _notifications.zonedSchedule(
//       id,
//       title,
//       body,
//       tzScheduledDate,
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time, // Schedule daily
//     );
//   }
// }
