import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/auth_controller.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/community_id.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/models/notification_model.dart';
import 'package:motazen/pages/communities_page/community/community_home.dart';
import 'package:motazen/theme.dart';

class NotificationController {
  CommunityController communityController = Get.find<CommunityController>();
  AuthController authController = Get.find<AuthController>();
  Set<String> sentAlertNotifications = {};
  final StreamController<List<NotificationModel>>
      _notificationsStreamController =
      StreamController<List<NotificationModel>>.broadcast();

  Stream<List<NotificationModel>> get notificationsStream =>
      _notificationsStreamController.stream;

  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _notificationsSubscription;

  void listenToNotifications(List<String> selectedAspects) async {
    try {
      _notificationsSubscription = FirebaseFirestore.instance
          .collection('user')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('notifications')
          .snapshots()
          .listen((querySnapshot) async {
        final notifications =
            await getNotifications(querySnapshot, selectedAspects);
        _notificationsStreamController.add(notifications);
      }, onError: (error) {
        log('Error listening to notifications: $error');
      });
    } catch (error) {
      log('Error listening to notifications: $error');
    }
  }

  void cancelNotificationsSubscription() {
    _notificationsSubscription.cancel();
    _notificationsStreamController.close();
  }

  Future<List<NotificationModel>> getNotifications(
      QuerySnapshot<Map<String, dynamic>> querySnapshot,
      List<String> selectedAspects) async {
    final List<NotificationModel> notifications = [];

    for (final doc in querySnapshot.docs
        .cast<QueryDocumentSnapshot<Map<String, dynamic>>>()) {
      final notydoc = doc.data();

      // Check if it's an invitation and if the user has the community aspect
      if (notydoc['type'] == 'invite') {
        final communityAspect = notydoc['community']['aspect'];
        if (!selectedAspects.contains(communityAspect)) {
          await removeNotification(notificationId: doc.reference.id);
          // Send a notification to the sender
          final recipientId = notydoc['senderId'];
          final senderId = firebaseAuth.currentUser!.uid;
          final senderAvatar = authController.currentUser.value.avatarURL;
          final community = notydoc['community'];
          final userName = firebaseAuth.currentUser!.displayName!;
          const type = 'alert';

          await sendNotification(
            recipientId,
            senderAvatar: senderAvatar,
            community: community,
            senderId: senderId,
            type: type,
            userName: userName,
          );
          continue;
        }
      }

      // Check if the notification already exists in the list
      final alreadyExists =
          notifications.any((n) => n.notificationId == doc.reference.id);
      if (alreadyExists) {
        continue;
      } else if (notydoc['type'] == 'alert') {
        // Check if it's an alert notification and if the notificationOfTheCommunity value already exists in the list
        final notificationOfTheCommunity =
            notydoc['notificationOfTheCommunity'];
        final alreadyExists = notifications.any(
            (n) => n.notificationOfTheCommunity == notificationOfTheCommunity);
        if (alreadyExists) {
          continue;
        }
      }
      // Create a new notification model and add it to the list
      final notification = NotificationModel(
        notificationId: doc.reference.id,
        senderAvtar: notydoc['senderAvatar'] ?? '',
        senderID: notydoc['senderId'],
        comm: notydoc['community'] == null
            ? null
            : Community(
                progressList: notydoc['community']['progress_list'],
                isDeleted: notydoc['community']['isDeleted'],
                aspect: notydoc['community']['aspect'],
                communityName: notydoc['community']['communityName'],
                creationDate:
                    (notydoc['community']['creationDate'] as Timestamp)
                        .toDate(),
                founderUsername: notydoc['community']['founderUsername'],
                goalName: notydoc['community']['goalName'],
                isPrivate: notydoc['community']['isPrivate'],
                id: notydoc['community']['_id'],
              ),
        creationDate: (notydoc['creation_date'] as Timestamp).toDate(),
        post: notydoc['post'],
        reply: notydoc['reply'],
        userName: notydoc['userName'],
        notificationType: notydoc['type'] ?? 'invite',
        notificationOfTheCommunity: notydoc['communityLink'],
      );
      notifications.add(notification);
    }

    return notifications;
  }

  Future<void> removeNotification({required String notificationId}) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  void acceptInvitation(
      NotificationModel notification, aspectList, BuildContext context) {
    // Create a GlobalKey for the form
    final acceptInvitationFormKey = GlobalKey<FormState>();

    // Show a dialog that lets the user select a goal for the community
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: getgoals(notification.comm.aspect.toString()),
          builder: (BuildContext context, AsyncSnapshot<List<Goal>> snapshot) {
            // If the goal data has loaded, show the dialog
            if (snapshot.hasData) {
              List<Goal> goalsName = snapshot.data!;
              Goal selectedGoal = goalsName.first;

              return AlertDialog(
                title: Text(
                  "اختر هدف المجتمع من قائمة أهدافك",
                  style: titleText2,
                ),
                content: Form(
                  key: acceptInvitationFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        goalsName.isEmpty
                            ? const Text(
                                " ليس لديك أهداف متعلقة بهذا الجانب",
                              )
                            : DropdownButtonFormField(
                                menuMaxHeight: 200,
                                value: selectedGoal
                                    .id, // Set the initial value to the id of the first goal
                                items: goalsName.map((goal) {
                                  return DropdownMenuItem(
                                    value:
                                        goal.id, // Use the goal id as the value
                                    child: Text(goal.titel),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  selectedGoal = goalsName
                                      .firstWhere((goal) => goal.id == val);
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Color(0xFF66BF77),
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'من فضلك اختر الهدف المناسب للمجتمع';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: "الأهداف ",
                                  prefixIcon: Icon(
                                    Icons.pie_chart,
                                    color: Color(0xFF66BF77),
                                  ),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            // If the form is valid and the user has goals, create a CommunityID object and save it to the database
                            if (acceptInvitationFormKey.currentState!
                                    .validate() &&
                                goalsName.isNotEmpty) {
                              CommunityID newCom = _createCommunityID(
                                  notification, selectedGoal);
                              IsarService iser = IsarService();
                              await iser.saveCom(newCom);
                              await iser.createGoal(selectedGoal);
                              await _updateCommunityInDatabase(
                                  notification, newCom);
                              await communityController.acceptInvitation();
                              communityController.update();
                              removeNotification(
                                  notificationId: notification.notificationId);
                              Get.to(() => CommunityHomePage(
                                    comm: communityController
                                        .listOfJoinedCommunities.last,
                                    fromInvite: true,
                                  ));
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            "انضمام",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              // If the goal data hasn't loaded yet, show a loading indicator
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }

// Create a CommunityID object based on the notification and selected goal
  CommunityID _createCommunityID(
      NotificationModel notification, Goal selectedGoal) {
    CommunityID newCom = CommunityID(userID: IsarService.getUserID);
    newCom.communityId = notification.comm.id;
    newCom.goal.value = selectedGoal;
    selectedGoal.communities.add(newCom);
    return newCom;
  }

// Update the community in the database to include the new member and their progress
  Future<void> _updateCommunityInDatabase(
      NotificationModel notification, CommunityID newCom) async {
    final comDoc = await firestore
        .collection('private_communities')
        .doc(notification.comm.id)
        .get();
    final comData = comDoc.data()! as dynamic;
    List memeberProgressList = comData['progress_list'];
    memeberProgressList.add({
      firebaseAuth.currentUser!.uid: newCom.goal.value!.goalProgressPercentage
    });
    communityController.listOfJoinedCommunities.add(
      Community(
        progressList: notification.comm.progressList,
        communityName: notification.comm.communityName,
        aspect: notification.comm.aspect,
        isPrivate: notification.comm.isPrivate,
        isDeleted: notification.comm.isDeleted,
        founderUsername: notification.comm.founderUsername,
        creationDate: notification.comm.creationDate,
        goalName: notification.comm.goalName,
        id: notification.comm.id,
      ),
    );
    await firestore
        .collection('private_communities')
        .doc(notification.comm.id)
        .set({
      'aspect': notification.comm.aspect,
      'communityName': notification.comm.communityName,
      'creationDate': notification.comm.creationDate,
      'progress_list': memeberProgressList,
      'founderUsername': notification.comm.founderUsername,
      'goalName': notification.comm.goalName,
      'isPrivate': notification.comm.isPrivate,
      '_id': notification.comm.id,
      "isDeleted": notification.comm.isDeleted
    });
  }

  Future<void> sendNotification(
    String recipientId, {
    String? notificationId,
    String? senderAvatar,
    required String senderId,
    required String type,
    String? communityLink,
    dynamic post,
    required String userName,
    dynamic community,
    String? reply,
  }) async {
    // Create a message to send
    final Map<String, dynamic> data = {
      'senderAvatar': senderAvatar,
      'senderId': senderId,
      'userName': userName,
      'creation_date': FieldValue.serverTimestamp(),
    };

    if (type == 'invite' || type == 'alert') {
      data['type'] = type;
      data['community'] = community;
    } else if (type == 'alert') {
      data['type'] = type;
      data['community'] = community;
    } else if (type == 'reply') {
      data['type'] = type;
      data['communityLink'] = communityLink;
      data['post'] = post;
      data['reply'] = reply;
    } else {
      data['type'] = type;
      data['communityLink'] = communityLink;
      data['post'] = post;
    }

    try {
      // Write the notification to the recipient's notifications subcollection
      final notificationDocRef = FirebaseFirestore.instance
          .collection('user')
          .doc(recipientId)
          .collection('notifications')
          .doc(notificationId);
      await notificationDocRef.set(data);
    } catch (e) {
      // If there is an error sending the message or writing to the database, log the error
      log('Error sending notification: $e');
    }
  }

  rejectInvitaion(NotificationModel notification) {
    removeNotification(
      notificationId: notification.notificationId,
    );
  }

  //* this method to fetch the goals related to the community aspect in the invitation
  Future<List<Goal>> getgoals(String aspect) async {
    Aspect? aspectObj = await IsarService().getSepecificAspect(aspect);
    return aspectObj!.goals.toList();
  }
}
