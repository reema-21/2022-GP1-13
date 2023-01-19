// ignore_for_file: non_constant_identifier_names

import 'package:motazen/entities/CommunityID.dart';
import 'package:motazen/entities/LocalTask.dart';

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
  final Communities = IsarLinks<CommunityID>();
  // has a relation each goal belong to one aspect
  @Index() // to be always arranged based on the importance
  late int importance;
  late DateTime startData;
  late DateTime endDate;
  late int goalDuration;
  late String DescriptiveGoalDuration;
  double goalProgressPercentage = 0;
  String userID;
  Goal({required this.userID});
}
