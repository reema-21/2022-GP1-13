import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motazen/entities/task.dart';

class Community {
  String? communityName;
  String? founderUsername;
  String? aspect;
  String? goalName;
  bool? isPrivate;
  DateTime? tillDate;
  DateTime? creationDate;
  List<Task>? listOfTasks;
  String id;

  Community(
      {this.communityName,
      this.aspect,
      this.creationDate,
      this.tillDate,
      this.goalName,
      this.isPrivate,
      this.listOfTasks,
      this.founderUsername,
      required this.id});

  Map<String, dynamic> toJson() => {
        "communityName": communityName,
        "aspect": aspect,
        "isPrivate": isPrivate,
        "goalName": goalName,
        "creationDate": creationDate,
        "tillDate": tillDate,
        "listOfTasks": listOfTasks,
        "founderUsername": founderUsername,
        "_id": id
      };

  static Community fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Community(
        communityName: snapshot['communityName'],
        aspect: snapshot['aspect'],
        isPrivate: snapshot['isPrivate'],
        goalName: snapshot['goalName'],
        creationDate: snapshot['creationDate'],
        tillDate: snapshot['tillDate'],
        listOfTasks: snapshot['listOfTasks'],
        founderUsername: snapshot['founderUsername'],
        id: snapshot['_id']);
  }
}
