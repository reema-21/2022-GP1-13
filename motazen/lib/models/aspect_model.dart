import 'package:flutter/widgets.dart';

///------------------------------------------Model for piechart---------------------------------------------

class AspectModel {
  ///rename to aspect
  final String name;

  final double points;

  final int color;

  final IconData icon;

  AspectModel(
      {required this.name,
      this.points = 1.0,
      required this.color,
      required this.icon});
}
