import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart';
import 'package:trackmate/models/habit.dart';
import 'package:trackmate/models/app_setting.dart'; // Adjust the path as necessary
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // Initialize the Isar database
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> cancelNotifications(int habitId) async {
    await flutterLocalNotificationsPlugin.cancel(habitId);
  }

  Future<void> _scheduleNotification(
      int habitId, String habitName, DateTime reminderTime) async {
    final now = DateTime.now();
    final duration = reminderTime.difference(now);

    // Schedule the first notification immediately
    final initialDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'habit_reminder_channel',
        'Habit Reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      habitId,
      'Reminder: $habitName',
      'Time left: ${duration.inMinutes} minutes',
      tz.TZDateTime.now(tz.local)
          .add(Duration(seconds: 1)), // Schedule immediately
      initialDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // Calculate the interval until reminder time
    final int totalMinutes = duration.inMinutes;
    final int repeatIntervalMinutes = 5;
    final int numberOfRepeats = (totalMinutes / repeatIntervalMinutes).ceil();

    // Create a function to check if the habit is completed
    Future<void> checkAndCancelNotifications() async {
      final habit = await isar.habits.get(habitId);
      if (habit != null &&
          habit.completeDays.any((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day)) {
        // Habit is completed today; cancel further notifications
        await flutterLocalNotificationsPlugin.cancel(habitId);
        // You may want to cancel all notifications related to this habit
        // by keeping track of scheduled notification IDs
      }
    }

    // Schedule repeating notifications every 5 minutes until the reminder time
    for (int i = 1; i <= numberOfRepeats; i++) {
      final notificationTime =
          now.add(Duration(minutes: repeatIntervalMinutes * i));
      if (notificationTime.isBefore(reminderTime)) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          habitId + i, // Ensure unique ID for each notification
          'Reminder: $habitName',
          'Time left: ${duration.inMinutes - repeatIntervalMinutes * i} minutes',
          tz.TZDateTime.from(notificationTime, tz.local),
          initialDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }

    // Periodically check if the habit is completed and cancel notifications
    Timer.periodic(Duration(minutes: repeatIntervalMinutes), (timer) async {
      final habit = await isar.habits.get(habitId);
      if (habit != null &&
          habit.completeDays.any((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day)) {
        // Habit is completed today; cancel further notifications
        await flutterLocalNotificationsPlugin.cancel(habitId);
        timer.cancel();
      }
    });
  }

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema], // Ensure correct schema names
      directory: dir.path,
    );
  }

  // Ensure that the database is initialized before accessing it

  // Save the first date of app startup (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();

    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get the first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  final List<Habit> currentHabits = [];
  Future<void> addHabit(String habitName, DateTime? reminderTime) async {
    final newHabit = Habit()
      ..name = habitName
      ..reminderTime = reminderTime;

    await isar.writeTxn(() => isar.habits.put(newHabit));

    if (reminderTime != null) {
      _scheduleNotification(newHabit.id, habitName, reminderTime);
    }

    readHabits();
  }

  Future<void> readHabits() async {
    List<Habit> fetchHabits = await isar.habits.where().findAll();
    currentHabits.clear();
    currentHabits.addAll(fetchHabits);
    notifyListeners();
  }

  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        final today = DateTime.now();
        if (isCompleted && !habit.completeDays.contains(today)) {
          habit.completeDays.add(DateTime(
            today.year,
            today.month,
            today.day,
          ));
        } else {
          habit.completeDays.removeWhere(
            (date) =>
                date.year == today.year &&
                date.month == today.month &&
                date.day == today.day,
          );
        }
        await isar.habits.put(habit);
      });
    }
    readHabits();
  }

  // Update the name of a habit by its ID
  Future<void> updateHabitName(int id, String newName) async {
    // Find the specific habit
    final habit = await isar.habits.get(id);

    if (habit != null) {
      // Update habit name
      // Save updated habit back to the database
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    readHabits();
  }

  // Delete a habit by its ID
  Future<void> deleteHabit(int id) async {
    // Perform the delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    // Re-read from the database
    readHabits();
  }

  Map<DateTime, int> getHabitData({required bool isCompleted}) {
    final Map<DateTime, int> data = {};
    final List<DateTime> allDates = [];

    // Generate a list of all dates in the range
    for (var habit in currentHabits) {
      for (var date in habit.completeDays) {
        final key = DateTime(date.year, date.month, date.day);
        allDates.add(key);
      }
    }

    // Handle case where there are no completed dates
    if (allDates.isEmpty) {
      return {}; // Return an empty map if there are no dates
    }

    // Find the min and max dates
    final minDate = allDates.reduce((a, b) => a.isBefore(b) ? a : b);
    final maxDate = allDates.reduce((a, b) => a.isAfter(b) ? a : b);

    // Iterate through all dates between minDate and maxDate
    for (DateTime date = minDate;
        !date.isAfter(maxDate);
        date = date.add(Duration(days: 1))) {
      final key = DateTime(date.year, date.month, date.day);
      int count = 0;

      for (var habit in currentHabits) {
        if (habit.completeDays.contains(key)) {
          count += 1;
        }
      }

      if (isCompleted) {
        data[key] = count;
      } else {
        // Incomplete is calculated based on the total number of habits
        final totalHabits = currentHabits.length;
        data[key] = totalHabits - count;
      }
    }

    return data;
  }

  Map<DateTime, int> getCompletedHabitCounts() {
    return getHabitData(isCompleted: true);
  }

  Map<DateTime, int> getIncompleteHabitCounts() {
    return getHabitData(isCompleted: false);
  }
}
