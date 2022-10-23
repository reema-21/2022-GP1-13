import 'package:datatry/entities/aspect.dart';
import 'package:datatry/entities/goal.dart';
import 'package:isar/isar.dart';
part 'task.g.dart';
@collection 
class Task  { // i didn't find out whether there is a way to show inheretance in here 
Id id = Isar.autoIncrement;
  late String content;
  final goal = IsarLink<Goal>(); //each task belong to one goal 
  final  aspect = IsarLink<Aspect>(); // has a relation each task  belong to one aspect 
 late String duration ;
  late String taskDuration; 
 }