import 'package:motazen/entities/task.dart';

import '/entities/aspect.dart';
import 'package:isar/isar.dart';
import '/entities/task.dart';

part 'goal.g.dart';


@collection
class Goal {
  Id id = Isar.autoIncrement;
  late String titel;
  final task = IsarLink<Task>();
  final goalDependency = IsarLink<Goal>(); //if goal depends on onther gaol
  final aspect =IsarLink<Aspect>(); // has a relation each goal belong to one aspect
  @Index() // to be always arranged based on the importance
  late int importance;
  late DateTime dueDate;
  late int goalDuration;


}
