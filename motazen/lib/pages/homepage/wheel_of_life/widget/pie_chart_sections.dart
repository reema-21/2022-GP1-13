import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/pages/homepage/wheel_of_life/progress_screen.dart';
import '../../../../isar_service.dart';
import '/entities/aspect.dart';


class PieChartSections {

  List<PieChartSectionData> getSections(int touchedIndex, List<Aspect>? data) =>
      data!
          .asMap()
          .map<int, PieChartSectionData>((index, data) {
            double points = data.percentagePoints;

            final isTouched = index == touchedIndex;
            if (isTouched) {
Get.to(() =>  ProgressScreen(aspect: data, isr: IsarService() ,)); // sending the aspect to the page
            }

            final value = PieChartSectionData(
              color: Color(data.color).withOpacity(1),
              value: 22.5,
              title: '',
              radius: points * 1.13, //scale the data to the size of the wheel
            );

            return MapEntry(index, value);
          })
          .values
          .toList();
}
