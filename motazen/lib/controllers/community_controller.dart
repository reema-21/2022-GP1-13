// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:motazen/Sidebar_and_navigation/navigation-bar.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/models/user.dart';

import '../entities/task.dart';
import '../theme.dart';

class CommunityController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  RxList<dynamic> projects = <dynamic>[].obs;
  RxList<Community> listOfCreatedCommunities = <Community>[].obs;
  RxList<Community> listOfJoinedCommunities = <Community>[].obs;
  RxList<Community> listOfNotifications = <Community>[].obs;
  RxList shoppingList = [].obs;
  Rx<bool> isProfilePhotoUpdating = false.obs;
  Rx<bool> isProfileComplete = false.obs;
  Rx<bool> isPremiumUser = false.obs;
  Rx<String> name = ''.obs;
  Rx<String> email = ''.obs;
  Rx<String> sex = ''.obs;
  Rx<String> memberSince = ''.obs;
  Rx<String> trainingSession = ''.obs;
  Rx<DateTime> birthday = DateTime.now().obs;
  Rx<String> gender = ''.obs;
  Rx<String> profilePhoto = ''.obs;
  Rx<String> height = ''.obs;
  Rx<String> startWeight = ''.obs;
  Rx<String> currentWeight = ''.obs;
  Rx<String> goalWeight = ''.obs;
  Rx<String> goal = ''.obs;
  Rx<String> activityLevel = ''.obs;

  final Rx<String> _uid = "".obs;

  updateUserData(String uid) async {
    _uid.value = uid;
    await getUserData();
  }

  getNotifications() async {
    listOfNotifications.clear();
    try {
      var querySnapshot = await firestore
          .collection('user')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('notifications')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          var notydoc = doc.data();

          List<Task> listOfTasks = [];
          for (var task in notydoc['listOfTasks']) {
            listOfTasks.add(Task(
              TaskDependency: task['TaskDependency'],
              amountCompleted: task['amountCompleted'],
              duration: task['duration'],
              durationDescribtion: task['durationDescribtion'],
              // goal: task['goal'],
              // id: task['id'],
              name: task['name'],
              taskCompletionPercentage: task['taskCompletionPercentage'],
            ));
          }

          listOfNotifications.add(Community(
              aspect: notydoc['aspect'],
              communityName: notydoc['communityName'],
              creationDate: notydoc['creationDate'].toDate(),
              founderUsername: notydoc['founderUsername'],
              goalName: notydoc['goalName'],
              isPrivate: notydoc['isPrivate'],
              listOfTasks: listOfTasks,
              tillDate: notydoc['tillDate'].toDate(),
              id: notydoc['_id']));
        }
      } else {}
    } catch (e) {}
    update();
  }

  getUserData() async {
    listOfJoinedCommunities.clear();
    listOfCreatedCommunities.clear();

    dynamic userDoc;

    userDoc = await firestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .get();

    final userData = userDoc.data()! as dynamic;

    List createdCommunitiess = [];
    try {
      createdCommunitiess = userData['createdCommunities'];
    } catch (e) {}
    List joinedCommunitiess = [];
    try {
      joinedCommunitiess = userData['joinedCommunities'];
    } catch (e) {}

    for (var community in createdCommunitiess) {
      List<Task> listOfTasks = [];
      for (var task in community['listOfTasks']) {
        listOfTasks.add(Task(
          TaskDependency: task['TaskDependency'],
          amountCompleted: task['amountCompleted'],
          duration: task['duration'],
          durationDescribtion: task['durationDescribtion'],
          // goal: task['goal'],
          // id: task['id'],
          name: task['name'],
          taskCompletionPercentage: task['taskCompletionPercentage'],
        ));
      }
      listOfCreatedCommunities.add(Community(
          aspect: community['aspect'],
          founderUsername: community['founderUsername'],
          communityName: community['communityName'],
          creationDate: community['creationDate'].toDate(),
          goalName: community['goalName'],
          isPrivate: community['isPrivate'],
          listOfTasks: listOfTasks,
          tillDate: community['tillDate'].toDate(),
          id: community['_id']));
    }
    for (var community in joinedCommunitiess) {
      List<Task> listOfTasks = [];
      for (var task in community['listOfTasks']) {
        listOfTasks.add(Task(
          TaskDependency: task['TaskDependency'],
          amountCompleted: task['amountCompleted'],
          duration: task['duration'],
          durationDescribtion: task['durationDescribtion'],
          // goal: task['goal'],
          // id: task['id'],
          name: task['name'],
          taskCompletionPercentage: task['taskCompletionPercentage'],
        ));
      }
      listOfJoinedCommunities.add(Community(
          aspect: community['aspect'],
          founderUsername: community['founderUsername'],
          communityName: community['communityName'],
          creationDate: community['creationDate'].toDate(),
          goalName: community['goalName'],
          isPrivate: community['isPrivate'],
          listOfTasks: listOfTasks,
          tillDate: community['tillDate'].toDate(),
          id: community['_id']));
    }

    update();
  }

  createCommunity({
    required Community community,
    required List<Userr> invitedUsers,
  }) async {
    FutureGroup futureGroup = FutureGroup();

    try {
      await firestore
          .collection('user')
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'createdCommunities': listOfCreatedCommunities
            .map((e) => {
                  'aspect': e.aspect,
                  'communityName': e.communityName,
                  'creationDate': e.creationDate,
                  'founderUsername': e.founderUsername,
                  'goalName': e.goalName,
                  'isPrivate': e.isPrivate,
                  'listOfTasks': e.listOfTasks!.isNotEmpty
                      ? e.listOfTasks!.map((e) => e.toJson()).toList()
                      : [],
                  'tillDate': e.tillDate,
                  '_id': e.id
                })
            .toList(),
      }).then((value) async {
        // if (community.isPrivate == false) {
        //   await firestore
        //       .collection('Public Communities')
        //       .add(community.toJson());
        // }
        if (invitedUsers.isNotEmpty) {
          for (var user in invitedUsers) {
            futureGroup.add(firestore
                .collection('user')
                .doc(user.userID)
                .collection('notifications')
                .add({
              'aspect': community.aspect,
              'communityName': community.communityName,
              'creationDate': community.creationDate,
              'founderUsername': community.founderUsername,
              'goalName': community.goalName,
              'isPrivate': community.isPrivate,
              'listOfTasks': community.listOfTasks!.isNotEmpty
                  ? community.listOfTasks!.map((e) => e.toJson()).toList()
                  : [],
              'tillDate': community.tillDate,
              '_id': community.id
            }));
          }
        }
      });
      futureGroup.close();
      getSuccessSnackBar('New community created successfully');
      // Get.off(() => const navBar());
    } catch (e) {
      listOfCreatedCommunities.remove(community);
      getErrorSnackBar('Something went wrong, Please try again');
      Get.off(() => const navBar(
            selectedIndex: 2,
          ));
    }
  }

  acceptInvitation() async {
    try {
      await firestore
          .collection('user')
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'joinedCommunities': listOfJoinedCommunities
            .map((e) => {
                  'aspect': e.aspect,
                  'communityName': e.communityName,
                  'creationDate': e.creationDate,
                  'founderUsername': e.founderUsername,
                  'goalName': e.goalName,
                  // 'inviteFriendsList':
                  //     e.inviteFriendsList!.map((e) => e.toJson()).toList(),
                  'isPrivate': e.isPrivate,
                  'listOfTasks': e.listOfTasks,
                  'tillDate': e.tillDate,
                  '_id': e.id
                })
            .toList(),
      });
    } catch (e) {}
    Get.back();
  }

  removeNotification({required DateTime creationDateOfCommunity}) async {
    try {
      await firestore
          .collection('user')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('notifications')
          .where('creationDate', isEqualTo: creationDateOfCommunity)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } catch (e) {}
    // Get.back();
  }
}
