// ignore_for_file: file_names, camel_case_types

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/notifications_screen.dart/notification_details_popup.dart';
import 'package:motazen/pages/communities_page/community_home.dart';
import 'package:motazen/theme.dart';

import '../../Sidebar_and_navigation/sidebar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  CommunityController communityController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  void startTheTimer() {
    Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: const SideBar(),
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
                tooltip: 'View Requests'),
          ],
        ),
        backgroundColor: kWhiteColor,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                const Spacer(),
                txt(
                  txt: 'إشعاراتي',
                  fontSize: 32,
                  fontColor: kPrimaryColor,
                ),
                const Spacer(
                  flex: 2,
                )
              ],
            ),
            SizedBox(
              height: screenHeight(context) * 0.03,
            ),
            Obx(() {
              return communityController.listOfNotifications.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(30.0),
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
                            itemCount:
                                communityController.listOfNotifications.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 16, 8, 16),
                                child: Container(
                                  height: screenHeight(context) * 0.2,
                                  width: screenWidth(context),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (communityController
                                                .listOfNotifications[index]
                                                .comm !=
                                            null)
                                          txt(
                                              txt: communityController
                                                  .listOfNotifications[index]
                                                  .comm
                                                  .communityName
                                                  .toString(),
                                              fontSize: 24),
                                        if (communityController
                                                    .listOfNotifications[index]
                                                    .notificationType ==
                                                'reply' ||
                                            communityController
                                                    .listOfNotifications[index]
                                                    .notificationType ==
                                                'like')
                                          txt(
                                              txt: communityController
                                                  .listOfNotifications[index]
                                                  .userName
                                                  .toString(),
                                              fontSize: 24),
                                        if (communityController
                                                .listOfNotifications[index]
                                                .notificationType ==
                                            'invite')
                                          txt(
                                              txt:
                                                  '${communityController.listOfNotifications[index].comm.founderUsername.toString()} يدعوك للإنضمام إالى ${communityController.listOfNotifications[index].comm.communityName.toString()}',
                                              fontSize: 18),
                                        if (communityController
                                                .listOfNotifications[index]
                                                .notificationType ==
                                            'reply')
                                          txt(
                                              txt:
                                                  '${communityController.listOfNotifications[index].userName.toString()}  قام بالرد على الرسالة "${communityController.listOfNotifications[index].reply}"',
                                              fontSize: 18),
                                        if (communityController
                                                .listOfNotifications[index]
                                                .notificationType ==
                                            'like')
                                          txt(
                                              txt:
                                                  '${communityController.listOfNotifications[index].userName.toString()} قام بالتشجيع للرسالة "${communityController.listOfNotifications[index].post['text']}"',
                                              fontSize: 18),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (communityController
                                                        .listOfNotifications[
                                                            index]
                                                        .notificationType ==
                                                    'invite') {
                                                  notificationDetailsPopup(
                                                      context,
                                                      community:
                                                          communityController
                                                              .listOfNotifications[
                                                                  index]
                                                              .comm);
                                                } else if (communityController
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
                                                }
                                              },
                                              child: Container(
                                                height: screenHeight(context) *
                                                    0.05,
                                                width:
                                                    screenWidth(context) * 0.4,
                                                decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Center(
                                                    child: txt(
                                                        txt: 'التفاصيل',
                                                        fontSize: 16,
                                                        fontColor:
                                                            Colors.white)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
            })
          ]),
        ),
      ),
    );
  }
}
