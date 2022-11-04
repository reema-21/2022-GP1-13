// ignore_for_file: non_constant_identifier_names

import '/entities/task.dart';

import '/entities/aspect.dart';
import 'package:isar/isar.dart';

part 'goal.g.dart';

@collection
class Goal {
  Id id = Isar.autoIncrement;
  late String titel;
  final goalDependency = IsarLink<Goal>(); //if goal depends on onther gaol
<<<<<<< Updated upstream
  final aspect =
      IsarLink<Aspect>(); // has a relation each goal belong to one aspect
=======
  final aspect =IsarLink<Aspect>();
    final task = IsarLinks<Task>();
 // has a relation each goal belong to one aspect
>>>>>>> Stashed changes
  @Index() // to be always arranged based on the importance
  late int importance;
  late DateTime dueDate;
  late int goalDuration;
  late String DescriptiveGoalDuration;
}
