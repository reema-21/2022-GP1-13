// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/theme.dart';

import '../models/user.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  // Rx<bool> isAuthUpdating = false.obs;
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
    // ever(_user, loginRedirect);
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
          } catch (e) {}

          List joinedCommunitiess = [];
          try {
            joinedCommunitiess = user['joinedCommunities'];
          } catch (e) {}
          String userNamee = user['userName'];
          String emaill = user['email'];
          Timestamp signInDatee = user['signInDate'];
          String pass = user['password'];
          String userIDD = user['userID'];
          String firstNamee = user['firstName'];
          for (var community in createdCommunitiess) {
            // List<Task> listOfTasks = [];
            try {
              // for (var task in community['listOfTasks']) {
              //   listOfTasks.add(Task(
              //     TaskDependency: task['TaskDependency'],
              //     amountCompleted: task['amountCompleted'],
              //     duration: task['duration'],
              //     durationDescribtion: task['durationDescribtion'],
              //     // goal: task['goal'],
              //     // id: task['id'],
              //     name: task['name'],
              //     taskCompletionPercentage: task['taskCompletionPercentage'],
              //   ));
              // }
            } catch (e) {}

            try {
              createdCommnitiesOfUser.add(Community(
                  progressList: community['progress_list'],
                  aspect: community['aspect'],
                  founderUsername: community['founderUsername'],
                  communityName: community['communityName'],
                  creationDate: community['creationDate'].toDate(),
                  goalName: community['goalName'],
                  isPrivate: community['isPrivate'],
                  // listOfTasks: listOfTasks,
                  // tillDate: community['tillDate'].toDate(),
                  id: community['_id']));
            } catch (e) {}
          }

          for (var community in joinedCommunitiess) {
            // List<Task> listOfTasks = [];
            try {
              // for (var task in community['listOfTasks']) {
              //   listOfTasks.add(Task(
              //     TaskDependency: task['TaskDependency'],
              //     amountCompleted: task['amountCompleted'],
              //     duration: task['duration'],
              //     durationDescribtion: task['durationDescribtion'],
              //     // goal: task['goal'],
              //     // id: task['id'],
              //     name: task['name'],
              //     taskCompletionPercentage: task['taskCompletionPercentage'],
              //   ));
              // }
            } catch (e) {}
            try {
              joinedCommnitiesOfUser.add(Community(
                  progressList: community['progress_list'],
                  aspect: community['aspect'],
                  founderUsername: community['founderUsername'],
                  communityName: community['communityName'],
                  creationDate: community['creationDate'].toDate(),
                  goalName: community['goalName'],
                  isPrivate: community['isPrivate'],
                  // listOfTasks: listOfTasks,
                  // tillDate: community['tillDate'].toDate(),
                  id: community['_id']));
            } catch (e) {}
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
    } catch (e) {}
    update();
  }

  // loginRedirect(var user) async {
  //   bool firstRun = await IsFirstRun.isFirstRun();
  //   Timer(Duration(seconds: isLoging ? 0 : 2), () {
  //     if (user == null) {
  //       isLoging = false;
  //       update();
  //       firstRun
  //           ? Get.offAll(() => const StartNow())
  //           : Get.offAll(() => const Login());
  //     } else {
  //       isLoging = true;
  //       update();
  //       Get.to(() => const Q1());
  //     }
  //   });
  // }
}
