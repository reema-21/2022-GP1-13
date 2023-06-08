import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/theme.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  RxList<Userr> usersList = <Userr>[].obs;
  late Rx<Userr> currentUser = Userr().obs;
  Rx<int> loginAttempts = 0.obs;
  Rx<int> endTime = 0.obs;
  // late Rx<User?> _user;
  bool isLoging = false;
  // User? get user => _user.value;

  Rx<int> isObscure = 1.obs;

  @override
  void onClose() {
    super.onReady();
  }

//*this method to get the user avatarurl from firebase

  getUserAvatar() async {
    await firestore
        .collection("user")
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      var currentUserDoc = value.data();
      currentUser.value.avatarURL = currentUserDoc!["avatarURL"];
    });
  }

  //*this method to set the user avatar
  setUserAvatar(String userAvatarUrl) async {
    await firestore
        .collection("user")
        .doc(firebaseAuth.currentUser!.uid)
        .update({"avatarURL": userAvatarUrl});
  }

  getUsersList() async {
    usersList.clear();
    try {
      await firestore.collection('user').get().then((value) {
        for (var user in value.docs as dynamic) {
          List<Community> createdCommnitiesOfUser = [];
          List<Community> joinedCommnitiesOfUser = [];
          List createdCommunitiess = [];
          try {
            createdCommunitiess = user['createdCommunities'];
          } catch (e) {
            log('error in created: $e');
          }

          List joinedCommunitiess = [];
          try {
            joinedCommunitiess = user['joinedCommunities'];
          } catch (e) {
            log('error in joined: $e');
          }
          String userNamee = user.data()['userName'];
          String emaill = user.data()['email'];
          Timestamp signInDatee = user.data()['signInDate'];
          String pass = user.data()['password'];
          String userIDD = user.data()['userID'];
          String firstNamee = user.data()['firstName'];
          String? avatarURL = user.data()["avatarURL"];

          for (var community in createdCommunitiess) {
            try {
              createdCommnitiesOfUser.add(Community(
                  progressList: community[
                      'progress_list'], //this list isn't being saved in db
                  aspect: community['aspect'],
                  founderUserID: community['founderUserID'],
                  communityName: community['communityName'],
                  creationDate: community['creationDate'].toDate(),
                  goalName: community['goalName'],
                  isPrivate: community['isPrivate'],
                  isDeleted: community['isDeleted'],
                  id: community['_id']));
            } catch (e) {
              log('error in add created to list: $e');
            }
          }

          for (var community in joinedCommunitiess) {
            try {
              joinedCommnitiesOfUser.add(Community(
                  progressList: community['progress_list'],
                  aspect: community['aspect'],
                  founderUserID: community['founderUserID'],
                  communityName: community['communityName'],
                  creationDate: community['creationDate'].toDate(),
                  goalName: community['goalName'],
                  isPrivate: community['isPrivate'],
                  isDeleted: community['isDeleted'],
                  id: community['_id']));
            } catch (e) {
              log('error in add joined to list: $e');
            }
          }

          usersList.add(Userr(
              userName: userNamee,
              createdCommunities: createdCommnitiesOfUser,
              email: emaill,
              firstName: firstNamee,
              joinedCommunities: joinedCommnitiesOfUser,
              password: pass,
              signInDate: signInDatee.toDate(),
              userID: userIDD,
              avatarURL: avatarURL));
          // avatarURL: avatarURL
          ////! you need to fix this comment above
        }
      });
    } catch (e) {
      log('error(auth controller): $e');
    }
    update();
  }
}
