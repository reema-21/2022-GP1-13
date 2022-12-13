import 'package:isar/isar.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/entities/habit.dart';
part 'aspect.g.dart';

@collection
class Aspect {
  Id id = Isar.autoIncrement;
  late bool isSelected;
  late String name;
  late double percentagePoints;
  late int color;
  late int iconCodePoint;
  late String? iconFontFamily;
  late String? iconFontPackage;
  late bool iconDirection;
  final goals = IsarLinks<Goal>();
  final habits = IsarLinks<Habit>();



}
