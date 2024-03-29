import 'package:cloud_firestore/cloud_firestore.dart';

//REEMAS
class Community {
  String? communityName;
  String? founderUserID;
  String? aspect;
  String? goalName;
  bool isPrivate;
  bool isDeleted;

  DateTime? creationDate;
  List<dynamic> progressList;
  String id;

  Community(
      {this.communityName,
      this.aspect,
      required this.isDeleted,
      this.creationDate,
      this.goalName,
      required this.isPrivate,
      this.founderUserID,
      required this.progressList,
      required this.id});

  Map<String, dynamic> toJson() => {
        "communityName": communityName,
        "aspect": aspect,
        "isPrivate": isPrivate,
        "goalName": goalName,
        "creationDate": creationDate,
        "founderUserID": founderUserID,
        "_id": id,
        "progress_list": progressList,
        "isDeleted": isDeleted
      };

  static Community fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Community(
        communityName: snapshot['communityName'],
        aspect: snapshot['aspect'],
        isPrivate: snapshot['isPrivate'],
        goalName: snapshot['goalName'],
        creationDate: snapshot['creationDate'],
        founderUserID: snapshot['founderUserID'],
        id: snapshot['_id'],
        isDeleted: snapshot['isDeleted'],
        progressList: snapshot['progress_list']);
  }
}
