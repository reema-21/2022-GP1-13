import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '/entities/aspect.dart';

class PieChartSections {
  List<PieChartSectionData> getSections(int touchedIndex, List<Aspect>? data) =>
      // if not worikng check the old one an d start over form there
      data!
          .asMap()
          .map<int, PieChartSectionData>((index, data) {
            double points = data.percentagePoints;

            final isTouched = index == touchedIndex;
            if (isTouched) {
              //add code to move to info page
            }

            final value = PieChartSectionData(
              color: Color(data.color).withOpacity(1),
              value: 22.5,
              title: '',
              radius: points * 1.33, //scale the data to the size of the wheel
            );

            return MapEntry(index, value);
          })
          .values
          .toList();
}
