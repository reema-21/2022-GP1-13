import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  late Rx<User?> _user;
  bool isLoging = false;
  User? get user => _user.value;
  final _auth = FirebaseAuth.instance;

  Rx<int> isObscure = 1.obs;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(_auth.currentUser);
    _user.bindStream(_auth.authStateChanges());
  }

  @override
  void onClose() {
    super.onReady();
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
            log('error: $e');
          }

          List joinedCommunitiess = [];
          try {
            joinedCommunitiess = user['joinedCommunities'];
          } catch (e) {
            log('error: $e');
          }
          String userNamee = user['userName'];
          String emaill = user['email'];
          Timestamp signInDatee = user['signInDate'];
          String pass = user['password'];
          String userIDD = user['userID'];
          String firstNamee = user['firstName'];
          for (var community in createdCommunitiess) {
            try {} catch (e) {
              log('error: $e');
            }

            try {
              createdCommnitiesOfUser.add(Community(
                  progressList: community['progress_list'],
                  aspect: community['aspect'],
                  founderUsername: community['founderUsername'],
                  communityName: community['communityName'],
                  creationDate: community['creationDate'].toDate(),
                  goalName: community['goalName'],
                  isPrivate: community['isPrivate'],
                  id: community['_id']));
            } catch (e) {
              log('error: $e');
            }
          }

          for (var community in joinedCommunitiess) {
            try {} catch (e) {
              log('error: $e');
            }
            try {
              joinedCommnitiesOfUser.add(Community(
                  progressList: community['progress_list'],
                  aspect: community['aspect'],
                  founderUsername: community['founderUsername'],
                  communityName: community['communityName'],
                  creationDate: community['creationDate'].toDate(),
                  goalName: community['goalName'],
                  isPrivate: community['isPrivate'],
                  id: community['_id']));
            } catch (e) {
              log('error: $e');
            }
          }

          usersList.add(
            Userr(
                userName: userNamee,
                createdCommunities: createdCommnitiesOfUser,
                email: emaill,
                firstName: firstNamee,
                joinedCommunities: joinedCommnitiesOfUser,
                password: pass,
                signInDate: signInDatee.toDate(),
                userID: userIDD),
          );
        }
      });
    } catch (e) {
      log('error: $e');
    }
    update();
  }
}
