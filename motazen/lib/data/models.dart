import 'package:flutter/widgets.dart';

///------------------------------------------Model for piechart---------------------------------------------

class Data {
  ///rename to aspect
  final String name;

  final double points;

  final int color;

  final IconData icon;

  Data(
      {required this.name,
      this.points = 1.0,
      required this.color,
      required this.icon});
}
