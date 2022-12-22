// ignore_for_file: file_names, camel_case_types

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/pages/notifications_screen.dart/notification_details_popup.dart';
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
    communityController.getNotifications();
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  const Spacer(),
                  txt(
                    txt: 'My Notifications',
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
                return SizedBox(
                  height: communityController.listOfNotifications.isEmpty
                      ? screenHeight(context) * 0.3
                      : screenHeight(context),
                  child: communityController.listOfNotifications.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Center(
                            child: txt(
                                txt: 'No Notifications yet',
                                fontSize: 18,
                                fontColor: kPrimaryColor),
                          ))
                      : ListView.builder(
                          itemCount:
                              communityController.listOfNotifications.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                              child: Container(
                                height: screenHeight(context) * 0.2,
                                width: screenWidth(context),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
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
                                      txt(
                                          txt: communityController
                                              .listOfNotifications[index]
                                              .communityName
                                              .toString(),
                                          fontSize: 24),
                                      txt(
                                          txt:
                                              '${communityController.listOfNotifications[index].founderUsername.toString()} is inviting you to community ${communityController.listOfNotifications[index].communityName.toString()}',
                                          fontSize: 18),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              notificationDetailsPopup(context,
                                                  community: communityController
                                                          .listOfNotifications[
                                                      index]);
                                            },
                                            child: Container(
                                              height:
                                                  screenHeight(context) * 0.05,
                                              width: screenWidth(context) * 0.4,
                                              decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                  child: txt(
                                                      txt: 'Details',
                                                      fontSize: 16,
                                                      fontColor: Colors.white)),
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
                        ),
                );
              })
            ]),
          ),
        ),
      ),
    );
  }
}
