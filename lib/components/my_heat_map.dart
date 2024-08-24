import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final DateTime startDate;
  final Map<DateTime, int> datasets;
  const MyHeatMap({
    super.key,
    required this.startDate,
    required this.datasets,
  });

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 10;
    return HeatMapCalendar(
      datasets: datasets,
      monthFontSize: 24,
      defaultColor: Colors.grey[200],
      textColor: Colors.black,
      showColorTip: false,
      size: size,
      colorMode: ColorMode.color,
      colorsets: {
        1: Colors.green.shade100,
        2: Colors.green.shade200,
        3: Colors.green.shade300,
        4: Colors.green.shade400,
        5: Colors.green.shade500,
        6: Colors.green.shade600,
        7: Colors.green.shade700,
        8: Colors.green.shade800,
        9: Colors.green.shade900,
      },
    );
  }
}
