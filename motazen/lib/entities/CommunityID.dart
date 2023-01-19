// ignore_for_file: file_names, non_constant_identifier_names

import 'package:isar/isar.dart';
part 'CommunityID.g.dart';

@collection
class CommunityID {
  Id id = Isar.autoIncrement;
  late String CommunityId;

  String userID;
  CommunityID({required this.userID});
}
