import 'dart:developer';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:motazen/Sidebar_and_navigation/navigation_bar.dart';
import 'package:motazen/controllers/auth_controller.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/models/user.dart';

import '../models/notification_model.dart';
import '../theme.dart';

class CommunityController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  RxList<dynamic> projects = <dynamic>[].obs;

  RxList<Community> listOfCreatedCommunities = <Community>[].obs;
  RxList<Community> listOfJoinedCommunities = <Community>[].obs;
  RxList<NotificationModel> listOfNotifications = <NotificationModel>[].obs;
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
  dynamic notificationQuerySnapshot;
  final Rx<String> _uid = "".obs;
  AuthController authController = Get.find();

  updateUserData(String uid) async {
    _uid.value = uid;
    await getUserData();
  }

  List<Community> findAspectComm(Aspect aspect) {
    List<Community> aspectCommunities = [];
    for (var community in listOfCreatedCommunities) {
      if (community.aspect == aspect.name) {
        aspectCommunities.add(community);
      }
    }
    for (var community in listOfJoinedCommunities) {
      if (community.aspect == aspect.name) {
        aspectCommunities.add(community);
      }
    }
    return aspectCommunities;
  }

//* this method is for assigning the listofnotification a value . i will add all the notification exepct the invitetion for unselected aspec in this case i will send an alert notifaction to the sender
  getNotifications(List selectedAspect) async {
    try {
      listOfNotifications.clear();
    } catch (e) {
      log('error: $e');
    }

    try {
      if (notificationQuerySnapshot.docs.isNotEmpty) {
        for (var doc in notificationQuerySnapshot.docs) {
          var notydoc = doc.data();
          //first i will check if it is an  invition if so i will check the aspect and then delete it
          if (notydoc['community'] != null) {
            bool selecetd = false;
            for (var aspect in selectedAspect) {
              if (aspect.name == notydoc['community']['aspect']) {
                selecetd = true;
                break;
              }
            }
// here if it is not selected i will delete it
            if (!selecetd) {
              //not selected
              await firestore
                  .collection('user')
                  .doc(firebaseAuth.currentUser!.uid)
                  .collection('notifications')
                  .where('type', isEqualTo: "invite")
                  .where('creation_date', isEqualTo: notydoc['creation_date'])
                  .get()
                  .then((snapshot) {
                for (DocumentSnapshot ds in snapshot.docs) {
                  ds.reference.delete();
                }
              });
            }
          }

          try {
            listOfNotifications.add(
              NotificationModel(
                  senderAvtar: notydoc['sender_avatar'],
                  senderID: notydoc['sender_id'],
                  comm: notydoc['community'] == null
                      ? null
                      : Community(
                          progressList: notydoc['community']['progress_list'],
                          isDeleted: notydoc['community']['isDeleted'],
                          aspect: notydoc['community']['aspect'],
                          communityName: notydoc['community']['communityName'],
                          creationDate:
                              notydoc['community']['creationDate'].toDate(),
                          founderUsername: notydoc['community']
                              ['founderUsername'],
                          goalName: notydoc['community']['goalName'],
                          isPrivate: notydoc['community']['isPrivate'],
                          id: notydoc['community']['_id']),
                  creationDate: notydoc['creation_date'].toDate(),
                  post: notydoc['post'],
                  reply: notydoc['reply'],
                  userName: notydoc['userName'],
                  notificationType: notydoc['type'] ?? "invite",
                  notificationOfTheCommunity: notydoc['community_link']),
            );
          } catch (e) {
            log('error: $e');
          }
        }
        listOfNotifications
            .sort((b, a) => a.creationDate.compareTo(b.creationDate));
      }
    } catch (e) {
      log('error: $e');
    }
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
    } catch (e) {
      log('error: $e');
    }
    List joinedCommunitiess = [];
    try {
      joinedCommunitiess = userData['joinedCommunities'];
    } catch (e) {
      log('error: $e');
    }

//! the issue starts here
    for (var community in createdCommunitiess) {
      if (!(listOfCreatedCommunities
          .any((element) => element.id == community['_id']))) {
        listOfCreatedCommunities.add(Community(
            progressList: community['progress_list'],
            aspect: community['aspect'],
            founderUsername: community['founderUsername'],
            communityName: community['communityName'],
            creationDate: community['creationDate'].toDate(),
            goalName: community['goalName'],
            isPrivate: community['isPrivate'],
            isDeleted: community['isDeleted'],
            id: community['_id']));
      }
    }
    for (var community in joinedCommunitiess) {
      if (!(listOfJoinedCommunities
          .any((element) => element.id == community['_id']))) {
        listOfJoinedCommunities.add(Community(
            progressList: community['progress_list'],
            aspect: community['aspect'],
            founderUsername: community['founderUsername'],
            communityName: community['communityName'],
            creationDate: community['creationDate'].toDate(),
            goalName: community['goalName'],
            isPrivate: community['isPrivate'],
            isDeleted: community['isDeleted'],
            id: community['_id']));
      }
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
        'createdCommunities': listOfCreatedCommunities.map((e) {
          return {
            'aspect': e.aspect,
            'isDeleted': e.isDeleted,
            'communityName': e.communityName,
            'creationDate': e.creationDate,
            'progress_list': e.progressList,
            'founderUsername': e.founderUsername,
            'goalName': e.goalName,
            'isPrivate': e.isPrivate,
            '_id': e.id
          };
        }).toList(),
      }).then((value) async {
        if (invitedUsers.isNotEmpty) {
          for (var user in invitedUsers) {
            futureGroup.add(firestore
                .collection('user')
                .doc(user.userID)
                .collection('notifications')
                .add({
              'creation_date': community.creationDate,
              'type': 'invite',
              'community': {
                'isDeleted': community.isDeleted,
                'progress_list': community.progressList,
                'aspect': community.aspect,
                'communityName': community.communityName,
                'creationDate': community.creationDate,
                'founderUsername': community.founderUsername,
                'goalName': community.goalName,
                'isPrivate': community.isPrivate,
                '_id': community.id
              }
            }));
          }
        }
        if (!(community.isPrivate)) {
          await firestore
              .collection('public_communities')
              .doc(community.id)
              .set({
            'aspect': community.aspect,
            'communityName': community.communityName,
            'creationDate': community.creationDate,
            'progress_list': community.progressList,
            'founderUsername': community.founderUsername,
            'goalName': community.goalName,
            'isPrivate': community.isPrivate,
            'isDeleted': community.isDeleted,

            // 'listOfTasks': community.listOfTasks!.isNotEmpty
            //     ? community.listOfTasks!.map((e) => e.toJson()).toList()
            //     : [],
            // 'tillDate': community.tillDate,
            '_id': community.id
          });
        } else {
          //!here add to the private_communities collection
          await firestore
              .collection('private_communities')
              .doc(community.id)
              .set({
            'aspect': community.aspect,
            'communityName': community.communityName,
            'creationDate': community.creationDate,
            'progress_list': community.progressList,
            'founderUsername': community.founderUsername,
            'goalName': community.goalName,
            'isPrivate': community.isPrivate,
            'isDeleted': community.isDeleted,
            // 'listOfTasks': community.listOfTasks!.isNotEmpty
            //     ? community.listOfTasks!.map((e) => e.toJson()).toList()
            //     : [],
            // 'tillDate': community.tillDate,
            '_id': community.id
          });
        }
      });
      futureGroup.close();
      getSuccessSnackBar('تم انشاء المجتمع بنجاح');
      // Get.off(() => const NavBar());
    } catch (e) {
      listOfCreatedCommunities.remove(community);
      getErrorSnackBar('حدث خطأ ما ،عاود التسجيل مرة أخرى ');

      Get.off(() => const NavBar(
            selectedIndex: 1,
          )); // here you  might need to change the number
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
                  'progress_list': e.progressList,
                  'founderUsername': e.founderUsername,
                  'goalName': e.goalName,
                  'isPrivate': e.isPrivate,
                  '_id': e.id,
                  'isDeleted': e.isDeleted,
                })
            .toList(),
      });
    } catch (e) {
      log('error: $e');
    }
    Get.back();
  }

  removeNotification(
      {required DateTime creationDateOfCommunity, required String type}) async {
    try {
      await firestore
          .collection('user')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('notifications')
          .where('type', isEqualTo: type)
          .where('creation_date', isEqualTo: creationDateOfCommunity)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } catch (e) {
      log('error: $e');
    }
  }
}
