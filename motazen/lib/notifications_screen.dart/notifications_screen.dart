// ignore_for_file: file_names, camel_case_types

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/data/data.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/pages/communities_page/community_home.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import '../entities/CommunityID.dart';
import '../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  TextEditingController goalNameController = TextEditingController();

  Future<List<Goal>> getgoals(String aspect) async {
    IsarService iser = IsarService(); // initialize local storage
    Aspect? chosenAspect =
        Aspect(userID: IsarService.getUserID); //Note: what is this used for
    chosenAspect = await iser.getSepecificAspect(aspect);

    List<Goal> goalList = chosenAspect!.goals.toList();
    return goalList;
  }

  CommunityController communityController = Get.find();

  @override
  void initState() {
    super.initState();
    // startTheTimer();
  }

  void startTheTimer() {
    Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<WheelData>(context, listen: false);

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/Notification_page.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("إشعاراتي",
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 32,
                color: kPrimaryColor,
              )),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ));
              },
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Obx(() {
                return communityController.listOfNotifications.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(100.0),
                        child: Center(
                          child: txt(
                              txt: 'لا يوجد اشعارات',
                              fontSize: 18,
                              fontColor: kPrimaryColor),
                        ))
                    : Expanded(
                        child: StreamBuilder(
                          stream: firestore
                              .collection('user')
                              .doc(firebaseAuth.currentUser!.uid)
                              .collection('notifications')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              communityController.notificationQuerySnapshot =
                                  snapshot.data;
                              communityController.getNotifications();
                            }
                            return ListView.builder(
                                itemCount: communityController
                                    .listOfNotifications.length,
                                itemBuilder: (context, index) {
                                  return Slidable(
                                      // Specify a key if the Slidable is dismissible.
                                      key: UniqueKey(),

                                      // The start action pane is the one at the left or the top side.
                                      startActionPane: ActionPane(
                                        // A motion is a widget used to control how the pane animates.
                                        motion: const ScrollMotion(),

                                        // A pane can dismiss the Slidable.
                                        dismissible:
                                            DismissiblePane(onDismissed: () {
                                          ///--------------------------------------------
                                          /// //here i'll check which type to delete it correctly
                                          if (communityController
                                                      .listOfNotifications[
                                                          index]
                                                      .notificationType ==
                                                  'reply' ||
                                              communityController
                                                      .listOfNotifications[
                                                          index]
                                                      .notificationType ==
                                                  'like') {
                                            final inA = communityController
                                                .listOfCreatedCommunities
                                                .indexWhere((e) =>
                                                    e.id ==
                                                    communityController
                                                        .listOfNotifications[
                                                            index]
                                                        .notificationOfTheCommunity);
                                            final inB = communityController
                                                .listOfJoinedCommunities
                                                .indexWhere((e) =>
                                                    e.id ==
                                                    communityController
                                                        .listOfNotifications[
                                                            index]
                                                        .notificationOfTheCommunity);
                                            final comm = inA >= 0
                                                ? communityController
                                                        .listOfCreatedCommunities[
                                                    inA]
                                                : inB >= 0
                                                    ? communityController
                                                        .listOfJoinedCommunities[inB]
                                                    : null;
                                            if (comm != null) {
                                              communityController.removeNotification(
                                                  creationDateOfCommunity:
                                                      communityController
                                                          .listOfNotifications[
                                                              index]
                                                          .creationDate,
                                                  type:
                                                      '${communityController.listOfNotifications[index].notificationType}');
                                            }
                                          }
                                          //-----
                                          ///
                                        }),

                                        // All actions are defined in the children parameter.
                                        children: [
                                          // A SlidableAction can have an icon and/or a label.
                                          SlidableAction(
                                            onPressed: ((context) {
                                              //here i'll check which type to delete it correctly
                                              if (communityController
                                                          .listOfNotifications[
                                                              index]
                                                          .notificationType ==
                                                      'reply' ||
                                                  communityController
                                                          .listOfNotifications[
                                                              index]
                                                          .notificationType ==
                                                      'like') {
                                                final inA = communityController
                                                    .listOfCreatedCommunities
                                                    .indexWhere((e) =>
                                                        e.id ==
                                                        communityController
                                                            .listOfNotifications[
                                                                index]
                                                            .notificationOfTheCommunity);
                                                final inB = communityController
                                                    .listOfJoinedCommunities
                                                    .indexWhere((e) =>
                                                        e.id ==
                                                        communityController
                                                            .listOfNotifications[
                                                                index]
                                                            .notificationOfTheCommunity);
                                                final comm = inA >= 0
                                                    ? communityController
                                                            .listOfCreatedCommunities[
                                                        inA]
                                                    : inB >= 0
                                                        ? communityController
                                                            .listOfJoinedCommunities[inB]
                                                        : null;
                                                if (comm != null) {
                                                  communityController.removeNotification(
                                                      creationDateOfCommunity:
                                                          communityController
                                                              .listOfNotifications[
                                                                  index]
                                                              .creationDate,
                                                      type:
                                                          '${communityController.listOfNotifications[index].notificationType}');
                                                }
                                              }
                                              //-----
                                            }),
                                            backgroundColor:
                                                const Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'حذف',
                                          ),
                                        ],
                                      ),
                                      child: InkWell(
                                        child: notificationItem(
                                            communityController
                                                .listOfNotifications[index],
                                            aspectList),
                                        onTap: () {
                                          if (communityController
                                                      .listOfNotifications[
                                                          index]
                                                      .notificationType ==
                                                  'reply' ||
                                              communityController
                                                      .listOfNotifications[
                                                          index]
                                                      .notificationType ==
                                                  'like') {
                                            final inA = communityController
                                                .listOfCreatedCommunities
                                                .indexWhere((e) =>
                                                    e.id ==
                                                    communityController
                                                        .listOfNotifications[
                                                            index]
                                                        .notificationOfTheCommunity);
                                            final inB = communityController
                                                .listOfJoinedCommunities
                                                .indexWhere((e) =>
                                                    e.id ==
                                                    communityController
                                                        .listOfNotifications[
                                                            index]
                                                        .notificationOfTheCommunity);
                                            final comm = inA >= 0
                                                ? communityController
                                                        .listOfCreatedCommunities[
                                                    inA]
                                                : inB >= 0
                                                    ? communityController
                                                        .listOfJoinedCommunities[inB]
                                                    : null;
                                            if (comm != null) {
                                              communityController.removeNotification(
                                                  creationDateOfCommunity:
                                                      communityController
                                                          .listOfNotifications[
                                                              index]
                                                          .creationDate,
                                                  type:
                                                      '${communityController.listOfNotifications[index].notificationType}');
                                              Get.to(CommunityHomePage(
                                                  comm: comm,
                                                  cameFromNotification:
                                                      communityController
                                                          .listOfNotifications[
                                                              index]
                                                          .post));
                                            }
                                          } else {
                                            communityController
                                                .listOfNotifications
                                                .remove(communityController
                                                    .listOfNotifications[index]
                                                    .comm);
                                            communityController
                                                .removeNotification(
                                                    creationDateOfCommunity:
                                                        communityController
                                                            .listOfNotifications[
                                                                index]
                                                            .creationDate,
                                                    type: 'invite');
                                            communityController.update();
                                          }
                                        },
                                      ));
                                });
                            //!----------------------------------------------!//
                            //                           ListView.builder(
                            //                             itemCount:
                            //                                 communityController.listOfNotifications.length,
                            //                             itemBuilder: (context, index) {
                            //                               return Padding(
                            //                                 padding:
                            //                                     const EdgeInsets.fromLTRB(8, 16, 8, 16),
                            //                                 child: Container(
                            //                                   height: screenHeight(context) * 0.2,
                            //                                   width: screenWidth(context),
                            //                                   decoration: BoxDecoration(
                            //                                       boxShadow: [
                            //                                         BoxShadow(
                            //                                           color: Colors.grey.withOpacity(0.5),
                            //                                           spreadRadius: 3,
                            //                                           blurRadius: 5,
                            //                                           offset: const Offset(0,
                            //                                               3), // changes position of shadow
                            //                                         ),
                            //                                       ],
                            //                                       color: Colors.white,
                            //                                       borderRadius: BorderRadius.circular(16)),
                            //                                   child: Padding(
                            //                                     padding: const EdgeInsets.all(16.0),
                            //                                     child: Column(
                            //                                       mainAxisAlignment:
                            //                                           MainAxisAlignment.spaceEvenly,
                            //                                       crossAxisAlignment:
                            //                                           CrossAxisAlignment.start,
                            //                                       children: [
                            //                                         //taking community name
                            //                                         if (communityController
                            //                                                 .listOfNotifications[index]
                            //                                                 .comm !=
                            //                                             null)
                            //                                           txt(
                            //                                               txt: communityController
                            //                                                   .listOfNotifications[index]
                            //                                                   .comm
                            //                                                   .communityName
                            //                                                   .toString(),
                            //                                               fontSize: 24),
                            // // know the type of the notification where a reply or a like or an invitaion
                            //                                         if (communityController
                            //                                                     .listOfNotifications[index]
                            //                                                     .notificationType ==
                            //                                                 'reply' ||
                            //                                             communityController
                            //                                                     .listOfNotifications[index]
                            //                                                     .notificationType ==
                            //                                                 'like')
                            //                                           txt(
                            //                                               txt: communityController
                            //                                                   .listOfNotifications[index]
                            //                                                   .userName
                            //                                                   .toString(),
                            //                                               fontSize: 24),
                            //                                         if (communityController
                            //                                                 .listOfNotifications[index]
                            //                                                 .notificationType ==
                            //                                             'invite')
                            //                                           txt(
                            //                                               txt:
                            //                                                   '${communityController.listOfNotifications[index].comm.founderUsername.toString()} يدعوك للإنضمام إالى ${communityController.listOfNotifications[index].comm.communityName.toString()}',
                            //                                               fontSize: 18),
                            //                                         if (communityController
                            //                                                 .listOfNotifications[index]
                            //                                                 .notificationType ==
                            //                                             'reply')
                            //                                           txt(
                            //                                               txt:
                            //                                                   '${communityController.listOfNotifications[index].userName.toString()}  قام بالرد على الرسالة "${communityController.listOfNotifications[index].reply}"',
                            //                                               fontSize: 18),
                            //                                         if (communityController
                            //                                                 .listOfNotifications[index]
                            //                                                 .notificationType ==
                            //                                             'like')
                            //                                           txt(
                            //                                               txt:
                            //                                                   '${communityController.listOfNotifications[index].userName.toString()} قام بالتشجيع للرسالة "${communityController.listOfNotifications[index].post['text']}"',
                            //                                               fontSize: 18),
                            //                                         Row(
                            //                                           mainAxisAlignment:
                            //                                               MainAxisAlignment.center,
                            //                                           children: [
                            //                                             InkWell(
                            //                                               onTap: () {
                            //                                                 if (communityController
                            //                                                         .listOfNotifications[
                            //                                                             index]
                            //                                                         .notificationType ==
                            //                                                     'invite') {
                            //                                                   notificationDetailsPopup(
                            //                                                       context,
                            //                                                       community:
                            //                                                           communityController
                            //                                                               .listOfNotifications[
                            //                                                                   index]
                            //                                                               .comm);
                            //                                                 } else if (communityController
                            //                                                             .listOfNotifications[
                            //                                                                 index]
                            //                                                             .notificationType ==
                            //                                                         'reply' ||
                            //                                                     communityController
                            //                                                             .listOfNotifications[
                            //                                                                 index]
                            //                                                             .notificationType ==
                            //                                                         'like') {
                            //                                                   final inA = communityController
                            //                                                       .listOfCreatedCommunities
                            //                                                       .indexWhere((e) =>
                            //                                                           e.id ==
                            //                                                           communityController
                            //                                                               .listOfNotifications[
                            //                                                                   index]
                            //                                                               .notificationOfTheCommunity);
                            //                                                   final inB = communityController
                            //                                                       .listOfJoinedCommunities
                            //                                                       .indexWhere((e) =>
                            //                                                           e.id ==
                            //                                                           communityController
                            //                                                               .listOfNotifications[
                            //                                                                   index]
                            //                                                               .notificationOfTheCommunity);
                            //                                                   final comm = inA >= 0
                            //                                                       ? communityController
                            //                                                               .listOfCreatedCommunities[
                            //                                                           inA]
                            //                                                       : inB >= 0
                            //                                                           ? communityController
                            //                                                               .listOfJoinedCommunities[inB]
                            //                                                           : null;
                            //                                                   if (comm != null) {
                            //                                                     communityController.removeNotification(
                            //                                                         creationDateOfCommunity:
                            //                                                             communityController
                            //                                                                 .listOfNotifications[
                            //                                                                     index]
                            //                                                                 .creationDate,
                            //                                                         type:
                            //                                                             '${communityController.listOfNotifications[index].notificationType}');
                            //                                                     Get.to(CommunityHomePage(
                            //                                                         comm: comm,
                            //                                                         cameFromNotification:
                            //                                                             communityController
                            //                                                                 .listOfNotifications[
                            //                                                                     index]
                            //                                                                 .post));
                            //                                                   }
                            //                                                 }
                            //                                               },
                            //                                               child: Container(
                            //                                                 height: screenHeight(context) *
                            //                                                     0.05,
                            //                                                 width:
                            //                                                     screenWidth(context) * 0.4,
                            //                                                 decoration: BoxDecoration(
                            //                                                     color: kPrimaryColor,
                            //                                                     borderRadius:
                            //                                                         BorderRadius.circular(
                            //                                                             5)),
                            //                                                 child: Center(
                            //                                                     child: txt(
                            //                                                         txt: 'التفاصيل',
                            //                                                         fontSize: 16,
                            //                                                         fontColor:
                            //                                                             Colors.white)),
                            //                                               ),
                            //                                             ),
                            //                                           ],
                            //                                         ),
                            //                                       ],
                            //                                     ),
                            //                                   ),
                            //                                 ),
                            //                               );
                            //                             },
                            //                           );
                          },
                        ),
                      );
              })
            ]),
          ),
        ),
      ),
    );
  }

  notificationItem(NotificationModel notification, aspectList) {
    //specify here the content based on the type of the notification
    String? type = notification.notificationType;
    String content = " ";
    switch (type) {
      case "reply":
        if (notification.post != null &&
            notification.post['image_url'] != null) {
          content = " قام بالرد على منشورك ";
        } else {
          content = " قام بالرد على رسالتك ";
        }

        break;
      case "like":
        if (notification.post != null &&
            notification.post['image_url'] != null) {
          content = " قام بتشجيع منشورك ";
        } else {
          content = "  قام بتشجيع رسالتك ";
        }
        break;
      case "invite":
        // String CommunityName = notification.comm.communityName.toString() ;
        content = "  يدعوك للإنضمام إلى مجتمع ";

        break;
    }

    //End of specifying the content
    int minAgo = (DateTime.now().toUtc().millisecondsSinceEpoch -
            notification.creationDate.millisecondsSinceEpoch) ~/
        (60 * 1000);
    String unit = 'دقيقة';
    if (minAgo > 60) {
      minAgo = minAgo ~/ 60;
      unit = 'ساعة';
      if (minAgo > 24) {
        minAgo = minAgo ~/ 24;
        unit = 'يوم';
        if (minAgo > 30) {
          minAgo = minAgo ~/ 30;
          unit = 'شهر';
          if (minAgo > 12) {
            minAgo = minAgo ~/ 30;
            unit = 'سنة';
          }
        }
      }
    }
    String timeAgo = "منذ ${minAgo.toString()} $unit ";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1)),
                    child: CircleAvatar(
                      backgroundImage:
                          const AssetImage("assets/images/Profile Image.webp"),
                      radius: 58,
                      child: Stack(children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.white70,
                              child: Image(
                                  image: notification.notificationType ==
                                          "invite"
                                      ? const AssetImage(
                                          "assets/images/invite.png")
                                      : notification.notificationType == "reply"
                                          ? const AssetImage(
                                              "assets/images/reply.png")
                                          : const AssetImage(
                                              "assets/images/like.png")) //"Icon made by Muhammad_Usman  from www.flaticon.com""Icon made by Circlon Tech from www.flaticon.com"
                              ),
                        ),
                      ]),
                    )
                    // ClipRRect(
                    //     borderRadius: BorderRadius.circular(50),
                    //     child: Icon(
                    //       Icons.account_circle_rounded,
                    //       size: 30,
                    //       color: Colors.grey,
                    //     )),
                    ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: notification.comm != null
                            ? notification.comm.founderUsername
                            : notification.userName,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: content,
                        style: const TextStyle(color: Colors.black)),
                    TextSpan(
                        text: notification.comm != null
                            ? notification.comm.communityName
                            : "",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    const TextSpan(text: "  "),
                    TextSpan(
                      text: timeAgo,
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    )
                  ])),
                )
              ],
            ),
          ),
          (notification.post != null && notification.post['image_url'] != null)
              ? SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                      child: CachedNetworkImage(
                    imageUrl: notification.post['image_url'],
                  )),
                )
              : Row(
                  children: [
                    notification.notificationType == 'invite'
                        ? Row(
                            children: [
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: (() {
                                  acceptInvitaion(notification, aspectList);
                                }),
                                child: const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: kPrimaryColor,
                                  size: 35.0,
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  rejectInvitaion(notification);
                                },
                                child: const Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.grey,
                                  size: 35.0,
                                ),
                              ),
                            ],
                          )
                        : const Text("")
                  ],
                )
        ],
      ),
    );
  }

  acceptInvitaion(NotificationModel notification, aspectList) {
    final _goalaspectController = TextEditingController();
    _goalaspectController.text = notification.comm.goalName!;

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

                  //! end of the button for adding task
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
//fetch the goal
//  Goal? choseGoal =
//                                   Goal(userID: IsarService.getUserID);
//                               IsarService iser =
//                                   IsarService(); // initialize local storage
//                               choseGoal = await iser.getgoal(
//                                 isSelected.,
//                               ); // here iam fetching the goal information from isar to assign it to the communties
                        //-----------------------------------
                        CommunityID newCom =
                            CommunityID(userID: IsarService.getUserID);
                        newCom.CommunityId = notification.comm.id;
                        isSelected.Communities.add(newCom);
                        IsarService iser = IsarService();
                        iser.createGoal(isSelected);
                        //-- here add the code of clicking accept
                        //here you should always add to the community in the private collection so first fetch it and then add and then update
                        //1-get the private community collection
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
//so after that code you add a new meber to the list now update the values
                        communityController.listOfJoinedCommunities.add(
                          Community(
                              progressList: notification.comm.progressList,
                              communityName: notification.comm.communityName,
                              aspect: notification.comm.aspect,
                              isPrivate: notification.comm.isPrivate,
                              founderUsername:
                                  notification.comm.founderUsername,
                              // tillDate: community.tillDate,
                              creationDate: notification.comm.creationDate,
                              goalName: notification.comm.goalName,
                              // listOfTasks: community.listOfTasks,
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
                          '_id': notification.comm.id
                        });

                        await communityController.acceptInvitation();
                        communityController.listOfNotifications
                            .remove(notification.comm);

                        communityController.removeNotification(
                            creationDateOfCommunity:
                                notification.comm.creationDate!,
                            type: 'invite');
                        communityController.update();
                        setState(() {});
                        Get.back();
                        Get.to(CommunityHomePage(
                            comm: communityController
                                .listOfJoinedCommunities.last));
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
    communityController.listOfNotifications.remove(notification.comm);
    communityController.removeNotification(
        creationDateOfCommunity: notification.creationDate, type: 'invite');
    communityController.update();
  }
}
