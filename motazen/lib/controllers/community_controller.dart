import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:motazen/Sidebar_and_navigation/navigation-bar.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/models/user.dart';
import '../models/notification_model.dart';
import '../theme.dart';
import 'dart:developer';

class CommunityController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  RxList<dynamic> projects = <dynamic>[].obs;

  RxList<Community> listOfCreatedCommunities = <Community>[].obs;
  RxList<Community> listOfJoinedCommunities = <Community>[].obs;
  RxList<NotificationModel> listOfNotifications = <NotificationModel>[].obs;
  Rx<String> name = ''.obs;

  FutureGroup futureGroup = FutureGroup();

//* retrieves the user's notifications from firebase
  getNotifications(List selectedAspect, var notificationQuerySnapshot) async {
    //! I commented the code for clearing the list to check if it's usefull or not
    // try {
    //   listOfNotifications.clear();
    // } catch (e) {
    //   log('error: $e');
    // }

    try {
      if (notificationQuerySnapshot.docs.isNotEmpty) {
        for (var notification in notificationQuerySnapshot.docs) {
          //retrieve the notification's data
          var notificationData = notification.data();

          //check if the user has the aspect of the notification
          bool selected = false;

          //? why do you check if the community index is not null? is related to notification types?
          // yes , there is fore types of notification the (like and replay types) don't have community but the (alert and the invite types) have
          //so here i want to do the code down for only the invite type
          //! in this case, use the type attribute (I believe there is one)
          if (notificationData['community'] != null) {
            for (var aspect in selectedAspect) {
              if (aspect.name == notificationData['community']['aspect']) {
                selected = true;
                break;
              } //end if
            } //end loop (selectedAspect)

            //if the aspect of the community has not been selected, enter the if statement
            if (!selected) {
              //Step1: delete the notification

              await notification.delete(); //! check if this works <3

              //Step2: send an alert to the sender
              //! this step should be implemented in a different method and then called here for maintainability And readability
              //retrieve current user's data
              final user = FirebaseAuth.instance.currentUser;

              //create a notification object for the alert
              final communityNotification = {
                'creation_date': DateTime.now(),
                'type': 'alert',
                'community': {
                  'progress_list': notificationData['community']
                      ['progress_list'],
                  'aspect': notificationData['community']['aspect'],
                  'communityName': notificationData['community']
                      ['communityName'],
                  'creationDate': notificationData['community']['creationDate'],
                  'founderUsername': notificationData['community']
                      ['founderUsername'],
                  'goalName': notificationData['community']['goalName'],
                  'isPrivate': notificationData['community']['isPrivate'],
                  '_id': notificationData['community']['_id']
                },
                'user_name': user?.displayName
              };

              //send the notification to the other user
              futureGroup.add(firestore
                  .collection('user')
                  .doc(notificationData['community']['progress_list'][0]
                      .toString()
                      .substring(
                          1,
                          notificationData['community']['progress_list'][0]
                              .toString()
                              .indexOf(':')))
                  .collection('notifications')
                  .add(communityNotification));
              continue;
            } //end if for !isSelected
          } // end if for (notificationData['community'] != null)

          //add the notification to the list of notification to be displayed
          listOfNotifications.add(
            NotificationModel(
                comm: notificationData['community'] == null
                    ? null
                    : Community(
                        progressList: notificationData['community']
                            ['progress_list'],
                        aspect: notificationData['community']['aspect'],
                        communityName: notificationData['community']
                            ['communityName'],
                        creationDate: notificationData['community']
                                ['creationDate']
                            .toDate(),
                        founderUsername: notificationData['community']
                            ['founderUsername'],
                        goalName: notificationData['community']['goalName'],
                        isPrivate: notificationData['community']['isPrivate'],
                        id: notificationData['community']['_id']),
                creationDate: notificationData['creation_date'].toDate(),
                post: notificationData['post'],
                reply: notificationData['reply'],
                userName: notificationData['user_name'],
                notificationType: notificationData['type'] ?? "invite",
                notificationOfTheCommunity: notificationData['community_link']),
          );
        } //end the notifications loop

        //sort the notifications list by date
        listOfNotifications
            .sort((b, a) => a.creationDate.compareTo(b.creationDate));
      }
    } catch (e) {
      log('error: $e');
    }

    //call the update mehtod to update the controller's data
    update();
  }

//retreive's the user's community data
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

    for (var community in createdCommunitiess) {
      listOfCreatedCommunities.add(Community(
          progressList: community['progress_list'],
          aspect: community['aspect'],
          founderUsername: community['founderUsername'],
          communityName: community['communityName'],
          creationDate: community['creationDate'].toDate(),
          goalName: community['goalName'],
          isPrivate: community['isPrivate'],
          id: community['_id']));
    }
    for (var community in joinedCommunitiess) {
      listOfJoinedCommunities.add(Community(
          progressList: community['progress_list'],
          aspect: community['aspect'],
          founderUsername: community['founderUsername'],
          communityName: community['communityName'],
          creationDate: community['creationDate'].toDate(),
          goalName: community['goalName'],
          isPrivate: community['isPrivate'],
          id: community['_id']));
    }

    update();
  }

//create a community
  createCommunity({
    required Community community,
    required List<Userr> invitedUsers,
  }) async {
    try {
      await firestore
          .collection('user')
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'createdCommunities': listOfCreatedCommunities.map((e) {
          return {
            'aspect': e.aspect,
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
            '_id': community.id
          });
        }
      });
      futureGroup.close();
      getSuccessSnackBar('تم انشاء المجتمع بنجاح');
    } catch (e) {
      listOfCreatedCommunities.remove(community);
      getErrorSnackBar('حدث خطأ ما ،عاود التسجيل مرة أخرى ');

      Get.off(() => const navBar(
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
                  '_id': e.id
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
