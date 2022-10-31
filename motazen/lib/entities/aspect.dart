import 'package:isar/isar.dart';
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
}
