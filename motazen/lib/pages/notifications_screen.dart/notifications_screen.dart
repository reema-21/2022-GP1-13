// ignore_for_file: file_names, camel_case_types
//Reemas //lastIntegration
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/pages/communities_page/community/community_home.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import '../../entities/CommunityID.dart';
import '../../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  TextEditingController goalNameController = TextEditingController();
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

  CommunityController communityController = Get.find();
  int length = 0;
  @override
  void initState() {
    super.initState();
    if (communityController.listOfNotifications.isNotEmpty) {
      setState(() {
        length = communityController.listOfNotifications.length;
      });
    }
    // startTheTimer();
  }

  void startTheTimer() {
    Timer.periodic(const Duration(seconds: 2), (_) {
      // setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context, listen: false);

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
              // Obx(() {
              // return
              length == 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'لا يوجد اشعارات حتي الان!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(
                              0xff2CBAA0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(64),
                          child: Image.asset(
                            'assets/images/no_notification.png',
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                          child: Text(
                            'سنخبرك عندما تحصل على اشعار جديد!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Color(
                                0xffA6C8C2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
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
                            communityController
                                .getNotifications(aspectList.selected);
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
                                      dismissible: //! ERROR this code delete only the like and reply invitaion we need to fix it to be able to delete invation and alert types only
                                          DismissiblePane(onDismissed: () {
                                        communityController.removeNotification(
                                            creationDateOfCommunity:
                                                communityController
                                                    .listOfNotifications[index]
                                                    .creationDate,
                                            type:
                                                '${communityController.listOfNotifications[index].notificationType}');
                                        if (communityController
                                                .listOfNotifications.length ==
                                            1) {
                                          communityController
                                              .listOfNotifications
                                              .clear();
                                          setState(() {
                                            length = 0;
                                          });
                                        }
                                        // if(communityController
                                        // .listOfNotifications.isEmpty){
                                        //   print("herllo");
                                        //    Get.to( NoNotificationScreen ()); // link the back to the right place
                                        // }
                                      }),

                                      // All actions are defined in the children parameter.
                                      children: [
                                        // A SlidableAction can have an icon and/or a label.
                                        SlidableAction(
                                          //! ERROR same as above
                                          onPressed: ((context) {
                                            communityController.removeNotification(
                                                creationDateOfCommunity:
                                                    communityController
                                                        .listOfNotifications[
                                                            index]
                                                        .creationDate,
                                                type:
                                                    '${communityController.listOfNotifications[index].notificationType}');
                                            if (communityController
                                                    .listOfNotifications
                                                    .length ==
                                                1) {
                                              communityController
                                                  .listOfNotifications
                                                  .clear();
                                              setState(() {
                                                length = 0;
                                              });
                                            }
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
                                      //* in here  i am specifying what to do when click on a notification
                                      child: notificationItem(
                                          communityController
                                              .listOfNotifications[index],
                                          aspectList),
                                      onTap: () {
                                        if (communityController
                                                    .listOfNotifications[index]
                                                    .notificationType ==
                                                'reply' ||
                                            communityController
                                                    .listOfNotifications[index]
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
                                                  .listOfCreatedCommunities[inA]
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
                                          // } else if (communityController
                                          //         .listOfNotifications[index]
                                          //         .notificationType ==
                                          //     'invite') {
                                          //   //TODO :here we might need to add a code to provide more details about the community
                                          // } else {
                                          //   //TODO: here add code for clicking on the alert if you want to add deatails
                                        }
                                      },
                                    ));
                              });
                        },
                      ),
                    )
              // })
            ]),
          ),
        ),
      ),
    );
  }

  //* to display the notification

  notificationItem(NotificationModel notification, aspectList) {
    //specify here the content based on the type of the notification
    String? type = notification.notificationType;
    String content = " ";
    switch (type) {
      // specify the content based on the type
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
      case "alert":
        content = " لايمكنك دعوة ${notification.userName} لمجتمع ";

        break;
    }

    //End of specifying the content
    int minAgo = (DateTime.now()
                .toUtc()
                .millisecondsSinceEpoch - // set the time of getting the notification
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
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                            // display the avatar if added
                            backgroundImage: notification.senderAvtar == ""
                                ? null
                                : CachedNetworkImageProvider(
                                    notification.senderAvtar!,
                                    errorListener: () {}),
                            radius: 32,
                            backgroundColor: kWhiteColor,

                            // ignore: prefer_const_constructors
                            child: notification.senderAvtar != ""
                                ? null
                                : const Icon(
                                    Icons
                                        .account_circle_sharp, //? is better to have the same icon as the one in the side bar
                                    color: Color.fromARGB(31, 0, 0, 0),
                                    size: 40,
                                  )),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: SizedBox(
                            height: 20,
                            width: 20,
                            child: Image(
                                image: notification.notificationType == "invite"
                                    ? const AssetImage(
                                        "assets/images/invite.png")
                                    : notification.notificationType == "reply"
                                        ? const AssetImage(
                                            "assets/images/reply.png")
                                        : notification.notificationType ==
                                                "like"
                                            ? const AssetImage(
                                                "assets/images/like.png")
                                            : const AssetImage(
                                                "assets/images/warning.png")) //"Icon made by Muhammad_Usman  from www.flaticon.com""Icon made by Circlon Tech from www.flaticon.com"

                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: notification.comm != null &&
                                notification.notificationType != "alert"
                            ? notification.comm.founderUsername
                            : notification.comm == null
                                ? notification.userName
                                : "",
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
                        CommunityID newCom =
                            CommunityID(userID: IsarService.getUserID);
                        newCom.CommunityId = notification.comm.id;
                        isSelected.Communities.add(newCom);
                        IsarService iser = IsarService();
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
                        communityController.listOfJoinedCommunities.add(
                          Community(
                              progressList: notification.comm.progressList,
                              communityName: notification.comm.communityName,
                              aspect: notification.comm.aspect,
                              isPrivate: notification.comm.isPrivate,
                              isDeleted: notification.comm.isDeleted,
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
                          '_id': notification.comm.id,
                          "isDeleted": notification.comm.isDeleted
                        });

                        await communityController.acceptInvitation();
                        communityController.listOfNotifications
                            .remove(notification.comm);

                        communityController.removeNotification(
                            creationDateOfCommunity:
                                notification.comm.creationDate!,
                            type: 'invite');
                        communityController.update();
                        // setState(() {});
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
