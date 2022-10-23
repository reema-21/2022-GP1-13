import 'package:isar/isar.dart';
import 'package:datatry/entities/aspect.dart';

part 'aspect.g.dart';
@collection
class Aspect{
  Id id = Isar.autoIncrement;
  late String name  ; 
}