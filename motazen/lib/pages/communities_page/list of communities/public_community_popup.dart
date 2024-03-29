import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/entities/community_id.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/pages/communities_page/community/community_home.dart';
import 'package:provider/provider.dart';

import '../../../theme.dart';

Future<dynamic> publicCommunityDetailsPopup(BuildContext context,
    {required Community community}) {
  var aspectList = Provider.of<AspectController>(context, listen: false);

  // here i am trying to get the list of goal form the same aspect as the community

  Future<List<Goal>> getgoals(String aspect) async {
    IsarService iser = IsarService(); // initialize local storage
    Aspect? chosenAspect = Aspect(userID: IsarService.getUserID);
    chosenAspect = await iser.getSepecificAspect(aspect);

    List<Goal> goalList = chosenAspect!.goals.toList();
    return goalList;
  }

  CommunityController communityController = Get.find();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          scrollable: true,
          content: Container(
            height: screenHeight(context) * 0.4,
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
                          child: Center(
                              child: Text(
                        community.communityName.toString(),
                        style: titleText2,
                      ))),
                      Expanded(
                        child: txt(
                          txt: 'جانب الحياة: ${community.aspect.toString()}',
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: txt(
                          txt: ' اسم الهدف: ${community.goalName.toString()}',
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () async {
                                Navigator.pop(
                                    context); // so that the join window goes

                                final goalaspectController =
                                    TextEditingController();
                                goalaspectController.text = community.goalName!;

                                final joinPublicCommunityFormKey = GlobalKey<
                                        FormState>(
                                    debugLabel:
                                        'joinPublicCommunityFormKey-${UniqueKey().toString()}');
                                Goal isSelected =
                                    Goal(userID: IsarService.getUserID);

                                List<Goal> goalsName = [];
                                getgoals(community.aspect.toString())
                                    .then((value) {
                                  aspectList.goalList = value;

                                  for (int i = 0;
                                      i < aspectList.goalList.length;
                                      i++) {
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
                                            key: joinPublicCommunityFormKey,
                                            child: SingleChildScrollView(
                                                child: Column(children: [
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              goalsName.isEmpty
                                                  ? const Text(
                                                      " ليس لديك أهداف متعلقة بهذا الجانب",
                                                    )
                                                  : DropdownButtonFormField(
                                                      menuMaxHeight: 200,
                                                      key: UniqueKey(),
                                                      value: null,
                                                      items: goalsName
                                                          .map((e) =>
                                                              DropdownMenuItem(
                                                                value: e,
                                                                child: Text(
                                                                    e.titel),
                                                              ))
                                                          .toList(),
                                                      onChanged: (val) {
                                                        isSelected = val!;
                                                      },
                                                      icon: const Icon(
                                                        Icons
                                                            .arrow_drop_down_circle,
                                                        color:
                                                            Color(0xFF66BF77),
                                                      ),
                                                      validator: (value) =>
                                                          value == null
                                                              ? 'من فضلك اختر الهدف المناسب للمجتمع'
                                                              : null,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText: "الأهداف ",
                                                        prefixIcon: Icon(
                                                          Icons.pie_chart,
                                                          color:
                                                              Color(0xFF66BF77),
                                                        ),
                                                        border:
                                                            UnderlineInputBorder(),
                                                      ),
                                                    ),
                                              const SizedBox(
                                                height: 30,
                                              ),

                                              //! end of the button for adding task
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<MaterialState>
                                                        states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .pressed)) {
                                                        return Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(0.4);
                                                      } else if (states
                                                          .contains(
                                                              MaterialState
                                                                  .disabled)) {
                                                        return const Color
                                                                .fromARGB(
                                                            136, 159, 167, 159);
                                                      }
                                                      return kPrimaryColor;
                                                    },
                                                  ),
                                                  padding:
                                                      const MaterialStatePropertyAll<
                                                              EdgeInsetsGeometry>(
                                                          kDefaultPadding),
                                                  textStyle:
                                                      const MaterialStatePropertyAll<
                                                          TextStyle>(
                                                    TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: 'Frutiger',
                                                    ),
                                                  ),
                                                ),
                                                //maybe the condition will be that user added one task
                                                //stateproblen
                                                onPressed: () async {
                                                  if (joinPublicCommunityFormKey
                                                          .currentState!
                                                          .validate() &&
                                                      goalsName.isNotEmpty) {
                                                    //-----------------------------------
                                                    CommunityID newCom =
                                                        CommunityID(
                                                            userID: IsarService
                                                                .getUserID);
                                                    newCom.communityId =
                                                        community.id;
                                                    newCom.goal.value =
                                                        isSelected;

                                                    isSelected.communities
                                                        .add(newCom);
                                                    IsarService iser =
                                                        IsarService();
                                                    iser.saveCom(newCom);

                                                    iser.createGoal(isSelected);
                                                    bool isJoined = false;
                                                    for (int i = 0;
                                                        i <
                                                            community
                                                                .progressList
                                                                .length;
                                                        i++) {
                                                      String x = community
                                                          .progressList[i]
                                                          .toString();
                                                      String userId =
                                                          x.substring(1,
                                                              x.indexOf(':'));
                                                      if (userId ==
                                                          firebaseAuth
                                                              .currentUser!
                                                              .uid) {
                                                        community
                                                            .progressList[i] = {
                                                          userId: isSelected
                                                              .goalProgressPercentage
                                                        };
                                                        isJoined = true;
                                                        break;
                                                      }
                                                    }
                                                    if (!isJoined) {
                                                      community.progressList
                                                          .add({
                                                        firebaseAuth
                                                                .currentUser!
                                                                .uid:
                                                            isSelected
                                                                .goalProgressPercentage
                                                      });
                                                    }

                                                    await firestore
                                                        .collection(
                                                            'public_communities')
                                                        .doc(community.id)
                                                        .set({
                                                      'aspect':
                                                          community.aspect,
                                                      'communityName': community
                                                          .communityName,
                                                      'creationDate': community
                                                          .creationDate,
                                                      'progress_list': community
                                                          .progressList,
                                                      'founderUserID': community
                                                          .founderUserID,
                                                      'goalName':
                                                          community.goalName,
                                                      'isPrivate':
                                                          community.isPrivate,
                                                      "isDeleted":
                                                          community.isDeleted,
                                                      '_id': community.id
                                                    });

                                                    dynamic userDoc;
                                                    userDoc = await firestore
                                                        .collection(
                                                            'public_communities')
                                                        .doc(community.id)
                                                        .get();
                                                    final userData = userDoc
                                                        .data()! as dynamic;

                                                    await firestore
                                                        .collection(
                                                            'public_communities')
                                                        .doc(community.id)
                                                        .update({
                                                      'aspect':
                                                          community.aspect,
                                                      'communityName': community
                                                          .communityName,
                                                      'creationDate': community
                                                          .creationDate,
                                                      'progress_list': userData[
                                                          'progress_list'],
                                                      'founderUserID': community
                                                          .founderUserID,
                                                      'goalName':
                                                          community.goalName,
                                                      'isPrivate':
                                                          community.isPrivate,
                                                      "isDeleted":
                                                          community.isDeleted,
                                                      '_id': community.id
                                                    });
                                                    communityController
                                                        .listOfJoinedCommunities
                                                        .add(
                                                      Community(
                                                        progressList: community
                                                            .progressList,
                                                        communityName: community
                                                            .communityName,
                                                        aspect:
                                                            community.aspect,
                                                        isPrivate:
                                                            community.isPrivate,
                                                        founderUserID: community
                                                            .founderUserID,
                                                        isDeleted:
                                                            community.isDeleted,
                                                        creationDate: community
                                                            .creationDate,
                                                        goalName:
                                                            community.goalName,
                                                        id: community.id,
                                                      ),
                                                    );
                                                    communityController
                                                        .update();
                                                    await communityController
                                                        .acceptInvitation(
                                                            community.id,
                                                            false);

                                                    // communityController
                                                    //     .update();
                                                    Get.to(() => CommunityHomePage(
                                                        fromInvite: false,
                                                        comm: communityController
                                                            .listOfJoinedCommunities
                                                            .last));
                                                  }
                                                },

                                                child: const Text("حسنا"),
                                              )
                                            ])),
                                          ));
                                    });
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
