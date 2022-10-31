import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '/data/models.dart';

class Sections {
  List<PieChartSectionData> getSections(int touchedIndex, List<Data> data) =>
      // if not worikng check the old one an d start over form there
      data
          .asMap()
          .map<int, PieChartSectionData>((index, data) {
            double points = data.points;

            final isTouched = index == touchedIndex;
            if (isTouched) {}

            final value = PieChartSectionData(
              color: Color(data.color),
              value: 22.5,
              title: '',
              radius: points,
            );

            return MapEntry(index, value);
          })
          .values
          .toList();
}
