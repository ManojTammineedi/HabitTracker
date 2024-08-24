import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final Function(BuildContext)? editHabit;
  final Function(BuildContext)? deleteHabit;
  // final Function(BuildContext)? setReminder;

  const HabitTile({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
    // required this.setReminder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: GestureDetector(
        onTap: () {
          if (onChanged != null) {
            onChanged!(!isCompleted);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green : Colors.white70,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26, // Shadow color
                blurRadius: 10, // Blur radius
                offset: Offset(0, 4), // Offset in the x and y direction
              ),
            ],
          ),
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Checkbox(
                activeColor: Colors.green,
                value: isCompleted,
                onChanged: onChanged,
              ),
              Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Poppins-Regular',
                    color: isCompleted ? Colors.white : Colors.black),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.settings, color: Colors.grey.shade800),
                onPressed: () {
                  if (editHabit != null) {
                    editHabit!(context);
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  if (deleteHabit != null) {
                    deleteHabit!(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
