import 'package:isar/isar.dart';
import 'package:motazen/entities/goal.dart';

part 'task.g.dart';

@collection
class Task {

  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
final TaskDependency = IsarLinks<Task>();
  late String  name;
final goal = IsarLink<Goal>();

  late int  duration;
  late String durationDescribtion;
}

