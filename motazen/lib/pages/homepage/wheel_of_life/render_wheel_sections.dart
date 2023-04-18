import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import '../../../entities/aspect.dart';

class WheelBackground extends StatefulWidget {
  const WheelBackground({super.key});

  @override
  State<WheelBackground> createState() => _WheelBackgroundState();
}

class _WheelBackgroundState extends State<WheelBackground> {
  //create the sections, border, and title for the outer sections of the wheel
  List<PieChartSectionData> getOutterSections(
      List<Aspect>? data, List<String>? arabicName) {
    //! do we still need this?
    var temp = arabicName!.asMap();
    return data!
        .asMap()
        .map<int, PieChartSectionData>((index, data) {
          final value = PieChartSectionData(
            borderSide: const BorderSide(
                color: kDarkGreyColor, style: BorderStyle.solid, width: 0.4),
            color: Color(data.color).withOpacity(0),
            title: temp[index],
            badgeWidget: Icon(
                IconData(
                  data.iconCodePoint,
                  fontFamily: data.iconFontFamily,
                  fontPackage: data.iconFontPackage,
                  matchTextDirection: data.iconDirection,
                ),
                color: Color(data.color)),
            titlePositionPercentageOffset: 1.47,
            badgePositionPercentageOffset: 1.14,
            radius: 100 * 1.2, //scale the data to the size of the wheel
          );

          return MapEntry(index, value);
        })
        .values
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);

    //render the background of the wheel
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(),
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 0,
        sections: getOutterSections(
            aspectList.selected, aspectList.getSelectedNames()),
      ),
    );
  }
}

//create the inner circles for the chart
Widget createCentralcircules(double radius) {
  double size = radius * 3.14;
  return Container(
    margin: const EdgeInsets.all(0.0),
    height: size,
    width: size,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      border: Border.symmetric(
        horizontal: BorderSide(
            color: kDarkGreyColor, style: BorderStyle.solid, width: 0.4),
        vertical: BorderSide(
            color: kDarkGreyColor, style: BorderStyle.solid, width: 0.4),
      ),
    ),
  );
}
