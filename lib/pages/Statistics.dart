import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trackmate/pages/Streaks.dart';

class Statistics extends StatefulWidget {
  final Map<DateTime, int> completedDatasets;
  final Map<DateTime, int> incompleteDatasets;

  const Statistics({
    super.key,
    required this.completedDatasets,
    required this.incompleteDatasets,
  });

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final double width = 8; // Adjusted width to accommodate two bars

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;
  bool hasData = false;
  int totalActiveDays = 0;
  int streak = 0;

  @override
  void initState() {
    super.initState();
    hasData = widget.completedDatasets.isNotEmpty ||
        widget.incompleteDatasets.isNotEmpty;
    if (hasData) {
      rawBarGroups = _mapDataToBarGroups(
          widget.completedDatasets, widget.incompleteDatasets);
      showingBarGroups = rawBarGroups;
      totalActiveDays = _calculateTotalActiveDays();
      streak = _calculateStreak();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(
          'Statistics',
          style: TextStyle(fontFamily: 'Bold-Poppins'),
        ),
        elevation: 2,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded, // Replace with your custom icon
            color: Colors.black, // Customize the icon color if needed
          ),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: !hasData
          ? Center(
              child: Text(
                'No data found',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                ),
              ),
            )
          : AspectRatio(
              aspectRatio: 0.7,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Active Days: $totalActiveDays',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          'Current Streak: $streak',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                    ),
                    Streaks(
                      completedDatasets: widget.completedDatasets,
                      incompleteDatasets: widget.incompleteDatasets,
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 17, 25, 60),
                          borderRadius:
                              BorderRadius.circular(16), // Rounded corners
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: BarChart(
                            BarChartData(
                              backgroundColor: Color.fromARGB(255, 17, 25, 60),
                              maxY:
                                  10, // Adjust this according to your data range
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (group) {
                                    return Color.fromARGB(255, 255, 255,
                                        255); // Tooltip text color
                                  },
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                    // Calculate the day of the week based on the x-axis value
                                    String weekDay =
                                        _getDayOfWeekFromIndex(group.x.toInt());

                                    return BarTooltipItem(
                                      '$weekDay\n',
                                      const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: (rod.toY).toString(),
                                          style: TextStyle(
                                            color: rod.color,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: _bottomTitles,
                                    reservedSize: 42,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    interval:
                                        5, // Adjust this for your data scale
                                    getTitlesWidget: _leftTitles,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),

                              barGroups: showingBarGroups,
                              gridData: const FlGridData(show: false),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  List<BarChartGroupData> _mapDataToBarGroups(
      Map<DateTime, int> completedData, Map<DateTime, int> incompleteData) {
    // Start from the first Monday and ensure every day of the week is covered
    final minDate = widget.completedDatasets.keys.isNotEmpty
        ? widget.completedDatasets.keys.reduce((a, b) => a.isBefore(b) ? a : b)
        : DateTime.now();
    final startOfWeek =
        minDate.subtract(Duration(days: minDate.weekday - 1)); // Monday

    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < 7; i++) {
      final currentDate = startOfWeek.add(Duration(days: i));
      final completedValue = completedData[currentDate] ?? 0;
      final incompleteValue = incompleteData[currentDate] ?? 0;

      barGroups.add(makeGroupData(
          i, completedValue.toDouble(), incompleteValue.toDouble()));
    }

    return barGroups;
  }

  BarChartGroupData makeGroupData(
      int x, double completedY, double incompleteY) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: completedY,
          color: const Color.fromARGB(255, 90, 253, 231),
          width: width,
        ),
        BarChartRodData(
          toY: incompleteY,
          color: const Color.fromARGB(255, 255, 100, 89),
          width: width,
        ),
      ],
      barsSpace: 4, // Space between the bars
    );
  }

  int _calculateTotalActiveDays() {
    // Combine completed and incomplete datasets, then count unique dates
    final allDates = widget.completedDatasets.keys.toSet()
      ..addAll(widget.incompleteDatasets.keys);
    return allDates.length;
  }

  int _calculateStreak() {
    final allDates = widget.completedDatasets.keys.toSet()
      ..addAll(widget.incompleteDatasets.keys);
    final sortedDates = allDates.toList()..sort();

    int maxStreak = 0;
    int currentStreak = 0;

    DateTime? previousDate;

    for (final date in sortedDates) {
      if (previousDate != null && date.difference(previousDate).inDays == 1) {
        currentStreak++;
      } else {
        currentStreak = 1;
      }
      maxStreak = currentStreak > maxStreak ? currentStreak : maxStreak;
      previousDate = date;
    }

    return maxStreak;
  }

  Widget _leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 5) {
      text = '5';
    } else if (value == 10) {
      text = '10';
    } else if (value == 15) {
      text = '15';
    } else if (value == 20) {
      text = '20';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    final titles = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final currentIndex =
        DateTime.now().weekday - 1; // Current day index (0 for Mon, 6 for Sun)

    // Highlight the current day by changing its text color
    final textColor =
        value.toInt() == currentIndex ? Colors.yellow : Colors.white;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(
        titles[value.toInt()],
        style: style.copyWith(color: textColor),
      ),
    );
  }

  String _getDayOfWeekFromIndex(int index) {
    final minDate =
        widget.completedDatasets.keys.reduce((a, b) => a.isBefore(b) ? a : b);
    final date = minDate.add(Duration(days: index));

    switch (date.weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}
