// ignore_for_file: list_remove_unrelated_type

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/pages/communities_page/community_home.dart';

import '../../theme.dart';

Future<dynamic> publicCommunityDetailsPopup(BuildContext context,
    {required Community community}) {
  CommunityController communityController = Get.find();
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inDays).round();
  }

  String duration =
      daysBetween(community.creationDate!, community.tillDate!).toString();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          scrollable: true,
          content: Container(
            height: community.listOfTasks!.isEmpty
                ? screenHeight(context) * 0.4
                : screenHeight(context) * 0.5,
            width: screenWidth(context) * 0.8,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: txt(
                          txt: community.communityName.toString(),
                          fontSize: 22,
                        ),
                      ),
                      Expanded(
                        child: txt(
                          txt: 'جانب الحياة: ${community.aspect.toString()}',
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: txt(
                          txt: 'المدة: $duration days ',
                          fontSize: 18,
                        ),
                      ),
                      community.listOfTasks!.isEmpty
                          ? Container()
                          : txt(
                              txt: 'المهام: ',
                              fontSize: 18,
                            ),
                      community.listOfTasks!.isEmpty
                          ? Container()
                          : Expanded(
                              flex: 3,
                              child: ListView.builder(
                                itemCount: community.listOfTasks!.length,
                                itemBuilder: (context, index) {
                                  return txt(
                                    txt:
                                        '\u2022 ${community.listOfTasks![index].name} ',
                                    fontSize: 18,
                                  );
                                },
                              ),
                            ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () async {
                                community.progressList
                                    .add({firebaseAuth.currentUser!.uid: 0});
                                communityController.listOfJoinedCommunities.add(
                                  Community(
                                      progressList: community.progressList,
                                      communityName: community.communityName,
                                      aspect: community.aspect,
                                      isPrivate: community.isPrivate,
                                      founderUsername:
                                          community.founderUsername,
                                      tillDate: community.tillDate,
                                      creationDate: community.creationDate,
                                      goalName: community.goalName,
                                      listOfTasks: community.listOfTasks,
                                      id: community.id),
                                );
                                communityController.update();
                                await communityController.acceptInvitation();

                                communityController.update();
                                setState(() {});
                                Get.to(CommunityHomePage(
                                    comm: communityController
                                        .listOfJoinedCommunities.last));
                              },
                              child: Container(
                                height: screenHeight(context) * 0.05,
                                width: screenWidth(context) * 0.2,
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: txt(
                                        txt: 'انضمام',
                                        fontSize: 16,
                                        fontColor: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              );
            }),
          ),
        );
      });
}
