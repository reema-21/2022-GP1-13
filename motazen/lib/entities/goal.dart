import 'package:motazen/entities/community_id.dart';
import 'package:motazen/entities/local_task.dart';
import '/entities/aspect.dart';
import 'package:isar/isar.dart';
part 'goal.g.dart';

@collection
class Goal {
  Id id = Isar.autoIncrement;
  late String titel;
  final goalDependency = IsarLink<Goal>(); //if goal depends on onther gaol
  final aspect = IsarLink<Aspect>();
  final task = IsarLinks<LocalTask>();
  final communities = IsarLinks<CommunityID>();
  // has a relation each goal belong to one aspect
  @Index() // to be always arranged based on the importance
  late int importance;
  late DateTime startData;
  late DateTime endDate;
  late int goalDuration;
  late String descriptiveGoalDuration;
  double goalProgressPercentage = 0;
  String userID;
  Goal({required this.userID});
}
