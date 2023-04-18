import 'goal.dart';
import 'package:isar/isar.dart';
part 'community_id.g.dart';

@collection
class CommunityID {
  Id id = Isar.autoIncrement;
  late String communityId;
  final goal = IsarLink<Goal>();
  String userID;

  CommunityID({required this.userID});
}
