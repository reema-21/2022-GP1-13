// ignore_for_file: camel_case_types, duplicate_ignore

import '../../../entities/aspect.dart';

import '/pages/homepage/wheel_of_life/widget/pie_chart_sections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class life_wheel extends StatefulWidget {
  final List<Aspect> allAspects;
  const life_wheel({super.key, required this.allAspects});

  @override
  State<life_wheel> createState() => Life_wheelState();
}

class Life_wheelState extends State<life_wheel> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(
          height: 18,
        ),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 0,
                sections: PieChartSections()
                    .getSections(touchedIndex, widget.allAspects),

                ///
              ),
            ),
          ),
        ),
      ],
    );
  }
}
