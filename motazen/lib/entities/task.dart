// ignore_for_file: non_constant_identifier_names

import 'package:isar/isar.dart';

import 'goal.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
  final TaskDependency = IsarLinks<Task>();
  @Index(type: IndexType.value)
  String? name;
  final goal = IsarLink<Goal>();

  @Index(type: IndexType.value)
  int? duration;
}
