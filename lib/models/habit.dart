import 'package:isar/isar.dart';
part 'habit.g.dart';

@Collection()
class Habit {
  Id id = Isar.autoIncrement;
  late String name;
  List<DateTime> completeDays = [];
  DateTime? reminderTime; // Add this line to store reminder time
}
