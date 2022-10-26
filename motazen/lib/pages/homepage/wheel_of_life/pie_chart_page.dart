import 'package:motazen/data/data.dart';

import '../../../data/models.dart';
import '/pages/homepage/wheel_of_life/widget/pie_chart_sections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class life_wheel extends StatefulWidget {
  final List<Data> dataList ; 
  const life_wheel({super.key, required this.dataList});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
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
                sections: getSections(touchedIndex , widget.dataList),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
