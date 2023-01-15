import '/entities/aspect.dart';

import 'package:isar/isar.dart';
part 'habit.g.dart';

@collection
class Habit {
  Id id = Isar.autoIncrement;
  late String titel;
  late String
      frequency; // i think we must provide the user to chose a number and then whether this number is within a month or a week .
  //late DateTime endDate //  i thought we can make is fixed to be today date +21
  final aspect = IsarLink<Aspect>();
  // has a relation each goal belong to one aspect

  late int durationInNumber;
  late int durationIndString; //for the dropdownmenue ;
  String userID;
  Habit({required this.userID});
}
