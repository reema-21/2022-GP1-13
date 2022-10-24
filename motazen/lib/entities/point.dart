import 'package:motazen/entities/point.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:isar/isar.dart';
part 'point.g.dart';

@collection
class Point {
  Id id = Isar.autoIncrement;
  late double finalValues;
  final aspect =
      IsarLink<Aspect>(); // has a relation each goal belong to one aspect

}
