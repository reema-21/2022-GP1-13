import 'package:isar/isar.dart';

part 'imporvment.g.dart';

@collection
class Imporvment {
  Id id = Isar.autoIncrement;
  late double sum;
  late DateTime date;
 String userID;
  Imporvment({required this.userID});



}