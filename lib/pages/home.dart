import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmate/components/habit_tile.dart';
import 'package:trackmate/components/my_heat_map.dart';
import 'package:trackmate/db/habit_database.dart';
import 'package:trackmate/models/habit.dart';
import 'package:trackmate/notification/firebase_api.dart';
import 'package:trackmate/pages/Statistics.dart';
import 'package:trackmate/pages/profile.dart';
import 'package:trackmate/util/habit_util.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  // TimeOfDay? _selectedTime;

  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
    // Load habits when the widget is first built
  }

  void checkReminderTime(Habit habit) {
    final now = DateTime.now();
    if (habit.reminderTime != null && habit.reminderTime!.isBefore(now)) {
      // Cancel notifications if the reminder time has passed
      context.read<HabitDatabase>().cancelNotifications(habit.id);
    }
  }

  void createNewHabit() {
    TimeOfDay? _selectedTime;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New Habit'),
        content: Column(
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: "Create a new habit",
              ),
            ),
            ListTile(
              title: Text(
                _selectedTime != null
                    ? 'Reminder Time: ${_selectedTime!.format(context)}'
                    : 'Set Reminder Time',
              ),
              trailing: Icon(Icons.access_time),
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
              String newHabitName = textController.text;
              DateTime? reminderDateTime;
              if (_selectedTime != null) {
                final now = DateTime.now();
                reminderDateTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  _selectedTime!.hour,
                  _selectedTime!.minute,
                );
              }

              context
                  .read<HabitDatabase>()
                  .addHabit(newHabitName, reminderDateTime);
              Navigator.pop(context);
              textController.clear();
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          MaterialButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
      checkReminderTime(habit);
      setState(() {});
    }
  }

  void editHabitBox(Habit habit) {
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
              String newHabitName = textController.text;
              context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, newHabitName);
              Navigator.pop(context);
              textController.clear();
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          MaterialButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure you want to delete?"),
        actions: [
          MaterialButton(
            color: Colors.red.shade600,
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(habit.id);
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          MaterialButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double spaceHeight = MediaQuery.of(context).size.height * 0.04;
    double spacewidth = MediaQuery.of(context).size.width * 0.04;
    User? user = FirebaseAuth.instance.currentUser;
    String loggedInEmail = user?.email ?? "No email";

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.1),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome",
              style: TextStyle(fontFamily: 'Bold-Poppins'),
            ),
            Text(
              loggedInEmail,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Poppins-Light',
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: spacewidth),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.bar_chart_rounded),
                  onPressed: () {
                    final habitDatabase =
                        Provider.of<HabitDatabase>(context, listen: false);
                    final completedData =
                        habitDatabase.getCompletedHabitCounts();
                    final incompleteData =
                        habitDatabase.getIncompleteHabitCounts();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Statistics(
                                completedDatasets: completedData,
                                incompleteDatasets: incompleteData,
                              )),
                    );
                  },
                ),
                SizedBox(
                  width: spacewidth,
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 2, // Set elevation to 0
        backgroundColor: Colors.white54, // Set the background color
        foregroundColor: Colors.black, // Set the color of the icon
        child: Icon(Icons.add), // Set the icon
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              30.0), // Adjust the radius to make it rounder
        ),
      ),
      body: Consumer<HabitDatabase>(
        builder: (context, habitDatabase, child) {
          List<Habit> currentHabits = habitDatabase.currentHabits;
          return ListView(
            children: [
              _buildHeatMap(habitDatabase),
              SizedBox(height: spaceHeight),
              _buildHabitList(currentHabits),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeatMap(HabitDatabase habitDatabase) {
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepHeatMapDataset(habitDatabase.currentHabits),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildHabitList(List<Habit> currentHabits) {
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        bool isCompletedToday = isHabitCompletedToday(habit.completeDays);

        return HabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
