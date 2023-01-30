// ignore_for_file: list_remove_unrelated_type, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/data/data.dart';
import 'package:motazen/entities/CommunityID.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/pages/communities_page/community_home.dart';
import 'package:provider/provider.dart';

import '../../theme.dart';

Future<dynamic> publicCommunityDetailsPopup(BuildContext context,
    {required Community community}) {
  var aspectList = Provider.of<WheelData>(context, listen: false);

  // here i am trying to get the list of goal form the same aspect as the community

  TextEditingController goalNameController = TextEditingController();

  Future<List<Goal>> getgoals(String aspect) async {
    IsarService iser = IsarService(); // initialize local storage
    Aspect? chosenAspect = Aspect(userID: IsarService.getUserID);
    String aspectnameInEnglish = "";
    switch (aspect) {
      case "أموالي":
        aspectnameInEnglish = "money and finances";
        break;
      case "متعتي":
        aspectnameInEnglish = "Fun and Recreation";

        break;
      case "مهنتي":
        aspectnameInEnglish = "career";

        break;
      case "علاقاتي":
        aspectnameInEnglish = "Significant Other";

        break;
      case "بيئتي":
        aspectnameInEnglish = "Physical Environment";
        break;
      case "ذاتي":
        aspectnameInEnglish = "Personal Growth";
        break;
      case "صحتي":
        aspectnameInEnglish = "Health and Wellbeing";
        break;
      case "عائلتي وأصدقائي":
        aspectnameInEnglish = "Family and Friends";
        break;
    }
    chosenAspect = await iser.getSepecificAspect(aspectnameInEnglish);

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

                                final _goalaspectController =
                                    TextEditingController();
                                _goalaspectController.text =
                                    community.goalName!;

                                final formKey = GlobalKey<FormState>();
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
                                            key: formKey,
                                            child: SingleChildScrollView(
                                                child: Column(children: [
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              //------
                                              DropdownButtonFormField(
                                                menuMaxHeight: 200,
                                                key: UniqueKey(),
                                                value: null,
                                                items: goalsName
                                                    .map((e) =>
                                                        DropdownMenuItem(
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
                                                validator: (value) => value ==
                                                        null
                                                    ? 'من فضلك اختر الهدف المناسب للمجتمع'
                                                    : null,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: "الأهدف ",
                                                  prefixIcon: Icon(
                                                    Icons.pie_chart,
                                                    color: Color(0xFF66BF77),
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
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    //-----------------------------------
                                                    CommunityID newCom =
                                                        CommunityID(
                                                            userID: IsarService
                                                                .getUserID);
                                                    newCom.CommunityId =
                                                        community.id;
                                                    isSelected.Communities.add(
                                                        newCom);
                                                    IsarService iser =
                                                        IsarService();
                                                    iser.createGoal(isSelected);

                                                    community.progressList.add({
                                                      firebaseAuth
                                                          .currentUser!.uid: 0
                                                    });
                                                    communityController
                                                        .listOfJoinedCommunities
                                                        .add(
                                                      Community(
                                                          progressList:
                                                              community
                                                                  .progressList,
                                                          communityName:
                                                              community
                                                                  .communityName,
                                                          aspect:
                                                              community.aspect,
                                                          isPrivate: community
                                                              .isPrivate,
                                                          founderUsername:
                                                              community
                                                                  .founderUsername,
                                                          creationDate:
                                                              community
                                                                  .creationDate,
                                                          goalName: community
                                                              .goalName,
                                                          id: community.id),
                                                    );
                                                    communityController
                                                        .update();
                                                    await communityController
                                                        .acceptInvitation();

                                                    communityController
                                                        .update();
                                                    Get.to(CommunityHomePage(
                                                        comm: communityController
                                                            .listOfJoinedCommunities
                                                            .last));
                                                  }
                                                },

                                                child: const Text("انتهيت"),
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
