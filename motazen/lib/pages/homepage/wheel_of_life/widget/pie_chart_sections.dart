import 'package:fl_chart/fl_chart.dart';
import 'package:datatry/data/data.dart';

List<PieChartSectionData> getSections(int touchedIndex) => WheelData().data
    .asMap()
    .map<int, PieChartSectionData>((index, data) {
      double points = data.points;
      final isTouched = index == touchedIndex;
      if (isTouched) {}

      final value = PieChartSectionData(
        color: data.color,
        value: 22.5,
        title: '',
        radius: points,
      );

      return MapEntry(index, value);
    })
    .values
    .toList();
