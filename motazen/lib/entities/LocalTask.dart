// ignore_for_file: non_constant_identifier_names, file_names

import 'package:isar/isar.dart';
import 'package:motazen/entities/goal.dart';
part 'LocalTask.g.dart';

@collection
class LocalTask {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
  final TaskDependency = IsarLinks<LocalTask>();
  late String name;
  final goal = IsarLink<Goal>();
  int amountCompleted = 0;
  double taskCompletionPercentage = 0;
  late int duration;
  late String durationDescribtion;
  bool completedForToday = false;
  String userID;
  LocalTask({required this.userID});
}
