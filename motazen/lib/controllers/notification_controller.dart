import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  CommunityController communityController = Get.put(CommunityController());
  final StreamController<List<NotificationModel>>
      _notificationsStreamController =
      StreamController<List<NotificationModel>>.broadcast();

  Stream<List<NotificationModel>> get notificationsStream =>
      _notificationsStreamController.stream;

  late StreamSubscription<QuerySnapshot> _notificationsSubscription;

  void listenToNotifications(List<String> selectedAspects) {
    _notificationsSubscription = FirebaseFirestore.instance
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('notifications')
        .snapshots()
        .listen((querySnapshot) {
      final notifications = getNotifications(querySnapshot, selectedAspects);
      _notificationsStreamController.add(notifications);
    });
  }

  void cancelNotificationsSubscription() {
    _notificationsSubscription.cancel();
    _notificationsStreamController.close();
  }

  List<NotificationModel> getNotifications(
      QuerySnapshot querySnapshot, List<String> selectedAspects) {
    final List<NotificationModel> notifications = [];

    for (final doc in querySnapshot.docs) {
      final notydoc = doc.data() as Map<String, dynamic>;

      // Check if it's an invitation and if the user has the community aspect
      if (notydoc['type'] == 'invite') {
        final communityAspect = notydoc['community']['aspect'];
        if (!selectedAspects.contains(communityAspect)) {
          removeNotification(notificationId: doc.reference.id);
          continue;
        }
      }

      // Check if the notification already exists in the list
      final alreadyExists =
          notifications.any((n) => n.notificationId == doc.reference.id);
      if (alreadyExists) {
        continue;
      }

      // Create a new notification model and add it to the list
      final notification = NotificationModel(
        notificationId: doc.reference.id,
        senderAvtar: notydoc['sender_avatar'],
        senderID: notydoc['sender_id'],
        comm: notydoc['community'] == null
            ? null
            : Community(
                progressList: notydoc['community']['progress_list'],
                isDeleted: notydoc['community']['isDeleted'],
                aspect: notydoc['community']['aspect'],
                communityName: notydoc['community']['communityName'],
                creationDate: notydoc['community']['creationDate'].toDate(),
                founderUsername: notydoc['community']['founderUsername'],
                goalName: notydoc['community']['goalName'],
                isPrivate: notydoc['community']['isPrivate'],
                id: notydoc['community']['_id'],
              ),
        creationDate: notydoc['creation_date'].toDate(),
        post: notydoc['post'],
        reply: notydoc['reply'],
        userName: notydoc['userName'],
        notificationType: notydoc['type'] ?? 'invite',
        notificationOfTheCommunity: notydoc['community_link'],
      );
      notifications.add(notification);
    }

    return notifications;
  }

  void removeNotification({required String notificationId}) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  acceptInvitaion(
      NotificationModel notification, aspectList, BuildContext context) {
    final goalaspectController = TextEditingController();
    goalaspectController.text = notification.comm.goalName!;

    final formKey = GlobalKey<FormState>();
    Goal isSelected = Goal(userID: IsarService.getUserID);

    List<Goal> goalsName = [];
    getgoals(notification.comm.aspect.toString()).then((value) {
      aspectList.goalList = value;

      for (int i = 0; i < aspectList.goalList.length; i++) {
        goalsName.add(aspectList.goalList[i]);
      }
    });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "اختر هدف المجتمع من قائمة أهدافك",
                style: titleText2,
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                    child: Column(children: [
                  const SizedBox(
                    height: 15,
                  ),
                  goalsName.isEmpty
                      ? const Text(
                          " ليس لديك أهداف متعلقة بهذا الجانب",
                        )
                      :

                      //------
                      DropdownButtonFormField(
                          menuMaxHeight: 200,
                          key: UniqueKey(),
                          value: null,
                          items: goalsName
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.titel),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            isSelected = val!;
                          },
                          icon: const Icon(
                            Icons.arrow_drop_down_circle,
                            color: Color(0xFF66BF77),
                          ),
                          validator: (value) => value == null
                              ? 'من فضلك اختر الهدف المناسب للمجتمع'
                              : null,
                          decoration: const InputDecoration(
                            labelText: "الأهدف ",
                            prefixIcon: Icon(
                              Icons.pie_chart,
                              color: Color(0xFF66BF77),
                            ),
                            border: UnderlineInputBorder(),
                          ),
                        ),
                  const SizedBox(
                    height: 30,
                  ),

                  // end of the button for adding task
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.4);
                          } else if (states.contains(MaterialState.disabled)) {
                            return const Color.fromARGB(136, 159, 167, 159);
                          }
                          return kPrimaryColor;
                        },
                      ),
                      padding:
                          const MaterialStatePropertyAll<EdgeInsetsGeometry>(
                              kDefaultPadding),
                      textStyle: const MaterialStatePropertyAll<TextStyle>(
                        TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Frutiger',
                        ),
                      ),
                    ),
                    //maybe the condition will be that user added one task
                    //stateproblen
                    onPressed: () async {
                      if (formKey.currentState!.validate() &&
                          goalsName.isNotEmpty) {
                        //here
                        CommunityID newCom =
                            CommunityID(userID: IsarService.getUserID);
                        newCom.communityId = notification.comm.id;
                        newCom.goal.value = isSelected;
                        isSelected.communities.add(newCom);

                        IsarService iser = IsarService();
                        iser.saveCom(newCom);

                        iser.createGoal(isSelected);

                        dynamic comDoc;
                        comDoc = await firestore
                            .collection('private_communities')
                            .doc(notification.comm.id)
                            .get();
                        final comData = comDoc.data()! as dynamic;
                        List memeberProgressList = [];
                        memeberProgressList = comData['progress_list'];

                        memeberProgressList.add({
                          firebaseAuth.currentUser!.uid:
                              isSelected.goalProgressPercentage
                        }); //! here i am changing the value for being zero when getting a community to the value of the chosen goal progress to be shared
                        communityController;
                        communityController.listOfJoinedCommunities.add(
                          Community(
                              progressList: notification.comm.progressList,
                              communityName: notification.comm.communityName,
                              aspect: notification.comm.aspect,
                              isPrivate: notification.comm.isPrivate,
                              isDeleted: notification.comm.isDeleted,
                              founderUsername:
                                  notification.comm.founderUsername,
                              creationDate: notification.comm.creationDate,
                              goalName: notification.comm.goalName,
                              id: notification.comm.id),
                        );
                        communityController.update();

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

                        await communityController.acceptInvitation();
                        // remove(notification.comm);
                        communityController.update();

                        removeNotification(
                          notificationId: notification.notificationId,
                        );
                        Get.to(() => CommunityHomePage(
                            comm: communityController
                                .listOfJoinedCommunities.last,
                            fromInvite: true));
                      }

                      //----------------------------------------------------//

                      else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("انضمام"),
                  )
                ])),
              ));
        });
  }

  rejectInvitaion(NotificationModel notification) {
    // _notifications.remove(notification.comm);
    removeNotification(
      notificationId: notification.notificationId,
    );
  }

  //* this method to fetch the goals related to the community aspect in the invitation
  Future<List<Goal>> getgoals(String aspect) async {
    IsarService iser = IsarService(); // initialize local storage
    Aspect? chosenAspect =
        Aspect(userID: IsarService.getUserID); //?Note: what is this used for
    // here I am creating an aspect object to fetch the shared goal aspect to check whether the user has goal related to this aspect or not
    chosenAspect = await iser.getSepecificAspect(aspect);

    List<Goal> goalList = chosenAspect!.goals.toList();
    return goalList;
  }
}
