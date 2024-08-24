import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:flutter/material.dart';

class Streaks extends StatefulWidget {
  final Map<DateTime, int> completedDatasets;
  final Map<DateTime, int> incompleteDatasets;

  const Streaks({
    super.key,
    required this.completedDatasets,
    required this.incompleteDatasets,
  });

  @override
  State<Streaks> createState() => _StreaksState();
}

class _StreaksState extends State<Streaks> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      GlobalKey<AnimatedCircularChartState>();
  final Size _chartSize = const Size(150.0, 150.0);

  late double completedPercentage;

  late double incompletePercentage;

  late int totalCompleted;
  late int totalIncomplete;

  @override
  void initState() {
    super.initState();
    _calculatePercentages();
  }

  void _calculatePercentages() {
    totalCompleted = widget.completedDatasets.values.fold(0, (a, b) => a + b);
    totalIncomplete = widget.incompleteDatasets.values.fold(0, (a, b) => a + b);
    int total = totalCompleted + totalIncomplete;

    if (total > 0) {
      completedPercentage = (totalCompleted / total) * 100;
      incompletePercentage = (totalIncomplete / total) * 100;
    } else {
      completedPercentage = 0;
      incompletePercentage = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    int total = totalCompleted + totalIncomplete;
    return Card(
      color: Color.fromARGB(255, 17, 25, 60),
      elevation: 0.4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          AnimatedCircularChart(
            key: _chartKey,
            size: _chartSize,
            initialChartData: <CircularStackEntry>[
              CircularStackEntry(
                <CircularSegmentEntry>[
                  CircularSegmentEntry(
                    incompletePercentage,
                    const Color.fromARGB(255, 255, 100, 89),
                    rankKey: 'Incomplete',
                  ),
                  CircularSegmentEntry(
                    completedPercentage,
                   const Color.fromARGB(255, 90, 253, 231),
                    rankKey: 'Complete',
                  ),
                ],
                rankKey: 'Progress',
              ),
            ],
            chartType: CircularChartType.Radial,
            percentageValues: true,
            holeLabel: '${totalCompleted.toString()} / ${total.toString()}',
            labelStyle: TextStyle(
              color:  Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
            duration: const Duration(milliseconds: 1000),
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 12,
                    width: 12,
                    color: const Color.fromARGB(255, 90, 253, 231),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Complete Habit',
                    style: const TextStyle(
                       color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Poppins-Medium',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Container(
                    height: 12,
                    width: 12,
                    color:  const Color.fromARGB(255, 255, 100, 89),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Incomplete Habit',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Poppins-Medium',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
