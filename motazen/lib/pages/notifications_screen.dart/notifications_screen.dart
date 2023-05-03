import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/controllers/notification_controller.dart';
import 'package:motazen/pages/communities_page/community/community_home.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import '../../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, required this.selectedAspects});
  final List<String> selectedAspects;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  TextEditingController goalNameController = TextEditingController();
  List<NotificationModel> _notifications = [];
  CommunityController communityController = Get.find();
  final NotificationController _notificationController =
      NotificationController();
  @override
  void initState() {
    super.initState();
    _listenToNotifications();
  }

  @override
  void dispose() {
    _notificationController.cancelNotificationsSubscription();
    super.dispose();
  }

  void _listenToNotifications() {
    _notificationController.listenToNotifications(widget.selectedAspects);
    _notificationController.notificationsStream.listen((notifications) {
      setState(() {
        _notifications = notifications;
      });
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
              _notifications.isEmpty
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
                      child: ListView.builder(
                          itemCount: _notifications.length,
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
                                    _notificationController.removeNotification(
                                        notificationId: _notifications[index]
                                            .notificationId);
                                    if (_notifications.length == 1) {
                                      _notifications.clear();
                                    }
                                  }),

                                  // All actions are defined in the children parameter.
                                  children: [
                                    // A SlidableAction can have an icon and/or a label.
                                    SlidableAction(
                                      //! ERROR same as above
                                      onPressed: ((context) {
                                        _notificationController
                                            .removeNotification(
                                          notificationId: _notifications[index]
                                              .notificationId,
                                        );
                                        if (_notifications.length == 1) {
                                          _notifications.clear();
                                        }
                                      }),
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'حذف',
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  //* in here  i am specifying what to do when click on a notification
                                  child: notificationItem(
                                      _notifications[index], aspectList),
                                  onTap: () {
                                    if (_notifications[index]
                                                .notificationType ==
                                            'reply' ||
                                        _notifications[index]
                                                .notificationType ==
                                            'like') {
                                      final inA = communityController
                                          .listOfCreatedCommunities
                                          .indexWhere((e) =>
                                              e.id ==
                                              _notifications[index]
                                                  .notificationOfTheCommunity);
                                      final inB = communityController
                                          .listOfJoinedCommunities
                                          .indexWhere((e) =>
                                              e.id ==
                                              _notifications[index]
                                                  .notificationOfTheCommunity);
                                      final comm = inA >= 0
                                          ? communityController
                                              .listOfCreatedCommunities[inA]
                                          : inB >= 0
                                              ? communityController
                                                  .listOfJoinedCommunities[inB]
                                              : null;
                                      if (comm != null) {
                                        _notificationController
                                            .removeNotification(
                                                notificationId:
                                                    _notifications[index]
                                                        .notificationId);
                                        Get.to(CommunityHomePage(
                                          comm: comm,
                                          cameFromNotification:
                                              _notifications[index].post,
                                          fromInvite: false,
                                        ));
                                      }
                                      //   //TODO :here we might need to add a code to provide more details about the community
                                      //   //TODO: here add code for clicking on the alert if you want to add deatails
                                    }
                                  },
                                ));
                          }),
                    )
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
                                    notification.senderAvtar,
                                    errorListener: () {}),
                            radius: 32,
                            backgroundColor: kWhiteColor,
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
                            ? notification.userName
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
                                  _notificationController.acceptInvitaion(
                                      notification, aspectList, context);
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
                                  _notificationController
                                      .rejectInvitaion(notification);
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
}
