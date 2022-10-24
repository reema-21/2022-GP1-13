import 'package:isar/isar.dart';
part 'aspect.g.dart';

@collection
class Aspect{
  Id id = Isar.autoIncrement;
  late String name  ; 
}