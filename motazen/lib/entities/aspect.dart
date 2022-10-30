import 'package:isar/isar.dart';
part 'aspect.g.dart';

@collection
class Aspect{
  Id id = Isar.autoIncrement;
  late bool isSelected;
  late String name  ; 
  late double percentagePoints ;//
}