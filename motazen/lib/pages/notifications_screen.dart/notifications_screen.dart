import 'dart:developer';
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
import 'package:motazen/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key, required this.selectedAspects})
      : super(key: key);
  final List<String> selectedAspects;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final TextEditingController goalNameController = TextEditingController();

  late CommunityController communityController;
  final NotificationController _notificationController =
      NotificationController();
  @override
  void initState() {
    super.initState();
    communityController = Get.find<CommunityController>();
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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final aspectList = context.watch<AspectController>();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Notification_page.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                "إشعاراتي",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 32,
                  color: kPrimaryColor,
                ),
              ),
              centerTitle: false,
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<List<NotificationModel>>(
                stream: _notificationController.notificationsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final notifications = snapshot.data!;

                    notifications.sort((a, b) {
                      final aMinutes = (DateTime.now()
                                  .toUtc()
                                  .millisecondsSinceEpoch -
                              a.creationDate.toUtc().millisecondsSinceEpoch) ~/
                          (60 * 1000);
                      final aUnit = getTimeUnit(aMinutes);
                      final bMinutes = (DateTime.now()
                                  .toUtc()
                                  .millisecondsSinceEpoch -
                              b.creationDate.toUtc().millisecondsSinceEpoch) ~/
                          (60 * 1000);
                      final bUnit = getTimeUnit(bMinutes);
                      if (aMinutes == bMinutes) {
                        //! check if this works
                        return aUnit.compareTo(bUnit);
                      } else {
                        return aMinutes.compareTo(bMinutes);
                      }
                    });
                    return notifications.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'لا يوجد اشعارات حتي الان!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff2CBAA0),
                                  ),
                                ),
                                SizedBox(height: 64),
                                Image(
                                  image: AssetImage(
                                      'assets/images/no_notification.png'),
                                ),
                                SizedBox(height: 16),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    'سنخبرك عندما تحصل على اشعار جديد!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff6A6A6A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              return Slidable(
                                startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  dragDismissible:
                                      false, //! for now it can cause a weird error, if there is time I will fix it
                                  // Use IndexedStack instead of Visibility
                                  children: [
                                    SlidableAction(
                                      onPressed: ((context) async {
                                        // Remove the notification when the delete button is pressed
                                        _notificationController
                                            .removeNotification(
                                          notificationId:
                                              notification.notificationId,
                                        );
                                      }),
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'حذف',
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    if (notification.notificationType ==
                                            'reply' ||
                                        notification.notificationType ==
                                            'like') {
                                      // Navigate to the community homepage if the notification is for a reply or a like
                                      final communityId = notification
                                          .notificationOfTheCommunity; // Replace with the ID of the community you want to get
                                      final community = communityController
                                          .getCommunityById(communityId);
                                      if (community != null) {
                                        //! remove the notification from the notification center
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CommunityHomePage(
                                              comm: community,
                                              cameFromNotification:
                                                  notifications[index].post,
                                              fromInvite: false,
                                            ),
                                          ),
                                        );
                                      } else {
                                        // Handle the case where no matching community was found
                                        log('error: no match community was found');
                                      }
                                    }
                                  },
                                  child: Stack(children: [
                                    notificationItem(
                                        notification, aspectList.selected),
                                    Positioned(
                                      bottom: 8.0,
                                      right: 8.0,
                                      child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Image(
                                              image: notification
                                                          .notificationType ==
                                                      "invite"
                                                  ? const AssetImage(
                                                      "assets/images/invite.png")
                                                  : notification
                                                              .notificationType ==
                                                          "reply"
                                                      ? const AssetImage(
                                                          "assets/images/reply.png")
                                                      : notification
                                                                  .notificationType ==
                                                              "like"
                                                          ? const AssetImage(
                                                              "assets/images/like.png")
                                                          : const AssetImage(
                                                              "assets/images/warning.png")) //"Icon made by Muhammad_Usman  from www.flaticon.com""Icon made by Circlon Tech from www.flaticon.com"

                                          ),
                                    ),
                                  ]),
                                ),
                              );
                            },
                          );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'خطأ: ${snapshot.error}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget notificationItem(NotificationModel notification, List aspectList) {
    // Determine the notification type using a switch statement
    String content;
    switch (notification.notificationType) {
      case 'reply':
        if (notification.post != null &&
            notification.post['image_url'] != null) {
          content = " قام بالرد على منشورك ";
        } else {
          content = " قام بالرد على رسالتك ";
        }
        break;
      case 'like':
        if (notification.post != null &&
            notification.post['image_url'] != null) {
          content = " قام بتشجيع منشورك ";
        } else {
          content = "  قام بتشجيع رسالتك ";
        }
        break;
      case 'invite':
        content = 'يدعوك للإنضمام إلى مجتمع ${notification.comm.communityName}';
        break;
      case 'alert':
        content =
            'لا يمكنك دعوة ${notification.userName} لمجتمع ${notification.comm.communityName}';
        break;
      default:
        content = '';
    }

    // Calculate the time ago string using DateTime methods
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

    return SizedBox(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(notification.senderAvtar),
        ),
        title: Text(
          '${notification.userName} $content',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          timeAgo,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: notification.notificationType == 'invite'
            ? SizedBox(
                width: 100.0,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _notificationController.acceptInvitation(
                            notification, aspectList, context);
                      },
                      icon: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: kPrimaryColor,
                        size: 35.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _notificationController.rejectInvitaion(notification);
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.grey,
                        size: 35.0,
                      ),
                    ),
                  ],
                ),
              )
            : (notification.notificationType != 'alert' &&
                    notification.post != null &&
                    notification.post['image_url'] != null)
                ? SizedBox(
                    width: 100,
                    child: ClipRRect(
                        child: CachedNetworkImage(
                      imageUrl: notification.post['image_url'],
                    )),
                  )
                : null,
      ),
    );
  }

  String getTimeUnit(minAgo) {
    String unit = 'دقيقة';
    if (minAgo > 60) {
      unit = 'ساعة';
      if (minAgo > 24) {
        unit = 'يوم';
        if (minAgo > 30) {
          unit = 'شهر';
          if (minAgo > 12) {
            unit = 'سنة';
          }
        }
      }
    }

    return unit;
  }
}
