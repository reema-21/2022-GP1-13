import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';

class WheelBackground extends StatelessWidget {
  const WheelBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the selected aspects and their names from the AspectController
    final aspectList = context.watch<AspectController>();
    final selectedAspects = aspectList.selected;
    final selectedNames = aspectList.getSelectedNames();

    // Create the sections for the outer part of the wheel
    final outerSections = selectedAspects.asMap().entries.map((entry) {
      final index = entry.key;
      final aspect = entry.value;
      return PieChartSectionData(
        borderSide: const BorderSide(
          color: kDarkGreyColor,
          style: BorderStyle.solid,
          width: 0.4,
        ),
        color: Color(aspect.color).withOpacity(0),
        title: selectedNames[index],
        badgeWidget: Icon(
          IconData(
            aspect.iconCodePoint,
            fontFamily: aspect.iconFontFamily,
            fontPackage: aspect.iconFontPackage,
            matchTextDirection: aspect.iconDirection,
          ),
          color: Color(aspect.color),
        ),
        titlePositionPercentageOffset: 1.47,
        badgePositionPercentageOffset: 1.14,
        radius: 100 * 1.2, // Scale the data to the size of the wheel
      );
    }).toList();

    // Create the background of the wheel
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(),
        borderData: FlBorderData(show: false),
        sectionsSpace: 0,
        centerSpaceRadius: 0,
        sections: outerSections,
      ),
    );
  }
}

// Create the inner circles for the chart
Widget createCentralcircles(double radius) {
  final size = radius * 3.14;
  return Container(
    margin: const EdgeInsets.all(0),
    height: size,
    width: size,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      border: Border.symmetric(
        horizontal: BorderSide(
          color: kDarkGreyColor,
          style: BorderStyle.solid,
          width: 0.4,
        ),
        vertical: BorderSide(
          color: kDarkGreyColor,
          style: BorderStyle.solid,
          width: 0.4,
        ),
      ),
    ),
  );
}
