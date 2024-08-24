// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:trackmate/db/habit_database.dart';
// import 'package:mockito/annotations.dart';

// @GenerateMocks([FlutterLocalNotificationsPlugin])
// void main() {
//   group('Notification Tests', () {
//     late HabitDatabase habitDatabase;
//     late MockFlutterLocalNotificationsPlugin mockNotificationsPlugin;

//     setUp(() {
//       mockNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
//       habitDatabase = HabitDatabase();
//       habitDatabase.flutterLocalNotificationsPlugin = mockNotificationsPlugin;
//     });

//     test('should schedule notification', () async {
//       final habitId = 1;
//       final habitName = 'Test Habit';
//       final reminderTime = DateTime.now().add(Duration(minutes: 10));

//       await habitDatabase._scheduleNotification(habitId, habitName, reminderTime);

//       verify(mockNotificationsPlugin.zonedSchedule(
//         habitId,
//         'Reminder: $habitName',
//         'Time left: ${reminderTime.difference(DateTime.now()).inMinutes} minutes',
//         any,
//         any,
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       )).called(1);
//     });
//   });
// }
