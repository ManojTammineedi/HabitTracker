// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:trackmate/db/habit_database.dart';
// import 'package:isar/isar.dart';
// import 'package:mockito/annotations.dart';
// import 'package:trackmate/models/habit.dart';

// @GenerateMocks([Isar])
// void main() {
//   group('HabitDatabase Tests', () {
//     late HabitDatabase habitDatabase;
//     late MockIsar mockIsar;

//     setUp(() {
//       mockIsar = MockIsar();
//       habitDatabase = HabitDatabase();
//       habitDatabase.isar = mockIsar;
//     });

//     test('should add a new habit and schedule notification', () async {
//       final habitName = 'Test Habit';
//       final reminderTime = DateTime.now().add(Duration(hours: 1));

//       // Mock the Isar behavior
//       when(mockIsar.writeTxn(any)).thenAnswer((_) async {});
//       when(mockIsar.habits.put(any)).thenAnswer((_) async {});

//       await habitDatabase.addHabit(habitName, reminderTime);

//       verify(mockIsar.writeTxn(any)).called(1);
//       verify(mockIsar.habits.put(any)).called(1);

//       // You might want to check if the notification was scheduled
//       // For example, by mocking FlutterLocalNotificationsPlugin
//     });

//     test('should update habit completion status', () async {
//       final habitId = 1;
//       final isCompleted = true;
//       final habit = Habit()..id = habitId;

//       when(mockIsar.habits.get(habitId)).thenAnswer((_) async => habit);
//       when(mockIsar.writeTxn(any)).thenAnswer((_) async {});

//       await habitDatabase.updateHabitCompletion(habitId, isCompleted);

//       verify(mockIsar.writeTxn(any)).called(1);
//       expect(habit.completeDays, isNotEmpty);
//     });
//   });
// }
