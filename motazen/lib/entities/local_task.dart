import 'package:isar/isar.dart';
import 'package:motazen/entities/goal.dart';
part 'local_task.g.dart';

@collection
class LocalTask {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
  final taskDependency = IsarLinks<LocalTask>();
  late String name;
  final goal = IsarLink<Goal>();
  int amountCompleted = 0;
  double taskCompletionPercentage = 0;
  late int duration;
  late String durationDescribtion;
  bool completedForToday = false;
  double rank = 0;
  String userID;
  DateTime? lastCompletionDate;
  LocalTask({required this.userID});
}
