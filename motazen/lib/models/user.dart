import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motazen/models/community.dart';

class Userr {
  String? email;
  String? firstName;
  String? password;
  String? userID;
  String? userName;
  DateTime? signInDate;
  List<Community>? createdCommunities;
  List<Community>? joinedCommunities;

  Userr({
    this.email,
    this.firstName,
    this.password,
    this.signInDate,
    this.userID,
    this.userName,
    this.createdCommunities,
    this.joinedCommunities,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "firstName": firstName,
        "password": password,
        "signInDate": signInDate,
        "userID": userID,
        "userName": userName,
        "createdCommunities": createdCommunities,
        "joinedCommunities": joinedCommunities,
      };

  static Userr fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Userr(
      email: snapshot['email'],
      firstName: snapshot['firstName'],
      password: snapshot['password'],
      signInDate: snapshot['signInDate'],
      userID: snapshot['userID'],
      userName: snapshot['userName'],
      createdCommunities: snapshot['createdCommunities'],
      joinedCommunities: snapshot['joinedCommunities'],
    );
  }
}
