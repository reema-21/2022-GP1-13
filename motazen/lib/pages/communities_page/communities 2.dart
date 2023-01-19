// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/pages/communities_page/community_home.dart';
import 'package:motazen/pages/communities_page/public_community_popup.dart';
import 'package:motazen/theme.dart';
import 'package:motazen/widget/greenContainer.dart';
import 'package:provider/provider.dart';

import '../../data/data.dart';
import '../../entities/aspect.dart';
import '../../models/community.dart';

class Communities extends StatefulWidget {
  const Communities({super.key});

  @override
  State<Communities> createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  bool isSearchCommunitySelected = false;
  bool isMyCommunitySelected = true;
  bool isFilterClicked = false;
  List<bool> whichFilter = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  CommunityController communityController = Get.find();

  @override
  void initState() {
    super.initState();
    userDataUpdate();
  }

  userDataUpdate() async {
    await communityController.getUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(
              flex: 2,
            ),
            txt(
              txt: 'مجتمعاتي',
              fontSize: 32,
              fontColor: kPrimaryColor,
            ),
            const Spacer()
          ],
        ),
        SizedBox(
          height: screenHeight(context) * 0.03,
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isSearchCommunitySelected = false;
                        isMyCommunitySelected = true;
                      });
                    },
                    child: communityScreenTabContainer(context,
                        color: isMyCommunitySelected
                            ? kPrimaryColor
                            : kPrimaryColor.withOpacity(0.5),
                        text: 'مجتمعات انا ضمنها'),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.02,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isSearchCommunitySelected = true;
                        isMyCommunitySelected = false;
                      });
                    },
                    child: communityScreenTabContainer(context,
                        color: isSearchCommunitySelected
                            ? kPrimaryColor
                            : kPrimaryColor.withOpacity(0.5),
                        text: 'المجتمعات العامة'),
                  ),
                ],
              ),
              Container(
                width: screenWidth(context),
                height: 1,
                color: Colors.grey.shade300,
              ),
              isSearchCommunitySelected
                  ? publicCommuntiesGrid(context)
                  : myCommunitiesSelectedContainer(context)
            ],
          ),
        )
      ],
    );
  }

  Expanded myCommunitiesSelectedContainer(BuildContext context) {
    bool joinedCommunitiesSelected = true;
    bool createdCommunitiesSelected = false;
    return Expanded(
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            SizedBox(
              height: screenHeight(context) * 0.025,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      createdCommunitiesSelected = true;
                      joinedCommunitiesSelected = false;
                    });
                  },
                  child: greenTextContainer(context,
                      text: 'مجتمعات بدأتها',
                      isSelected: createdCommunitiesSelected),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      createdCommunitiesSelected = false;
                      joinedCommunitiesSelected = true;
                    });
                  },
                  child: greenTextContainer(context,
                      text: 'مجتمعات انضممت لها',
                      isSelected: joinedCommunitiesSelected),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight(context) * 0.01,
            ),
            createdCommunitiesSelected
                ? CommunityTile(
                    communityController.listOfCreatedCommunities.value,
                    firebaseAuth.currentUser!.displayName)
                : CommunityTile(
                    communityController.listOfJoinedCommunities.value,
                    firebaseAuth.currentUser!.displayName)
          ],
        );
      }),
    );
  }

  Expanded publicCommuntiesGrid(BuildContext context) {
    var aspectList = Provider.of<WheelData>(context);
    aspectList.selectedArabic.forEach((element) {});
    return Expanded(
        child: Column(
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isFilterClicked = !isFilterClicked;
                  });
                },
                icon: const Icon(Icons.filter_alt)),
            InkWell(
                onTap: () {
                  setState(() {
                    isFilterClicked = !isFilterClicked;
                  });
                },
                child: const Text('Filter'))
          ],
        ),
        if (isFilterClicked)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: aspectList.selectedArabic.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 3.0,
                  mainAxisSpacing: 3.0,
                  mainAxisExtent: 40),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      whichFilter[index] = !whichFilter[index];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green),
                      color: whichFilter[index] ? Colors.green : Colors.white,
                    ),
                    height: 5,
                    child:
                        Center(child: Text(aspectList.selectedArabic[index])),
                  ),
                );
              },
            ),
          ),
        StreamBuilder(
            stream: firestore.collection('public_communities').snapshots(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                final publicCommunitiesDoc = snapshot.data!.docs;
                List<Community> publicCommunities = [];
                for (var community in publicCommunitiesDoc) {
                  if (!(communityController.listOfJoinedCommunities.indexWhere(
                              (element) => element.id == community['_id']) >=
                          0 ||
                      communityController.listOfCreatedCommunities.indexWhere(
                              (element) => element.id == community['_id']) >=
                          0)) {
                    // List<Task> listOfTasks = [];
                    // for (var task in community['listOfTasks']) {
                    //   listOfTasks.add(Task(
                    //     TaskDependency: task['TaskDependency'],
                    //     amountCompleted: task['amountCompleted'],
                    //     duration: task['duration'],
                    //     durationDescribtion: task['durationDescribtion'],
                    //     // goal: task['goal'],
                    //     // id: task['id'],
                    //     name: task['name'],
                    //     taskCompletionPercentage:
                    //         task['taskCompletionPercentage'],
                    //   ));
                    // }
                    publicCommunities.add(Community(
                        progressList: community['progress_list'],
                        aspect: community['aspect'],
                        founderUsername: community['founderUsername'],
                        communityName: community['communityName'],
                        creationDate: community['creationDate'].toDate(),
                        goalName: community['goalName'],
                        isPrivate: community['isPrivate'],
                        // listOfTasks: listOfTasks,
                        // tillDate: community['tillDate'].toDate(),
                        id: community['_id']));
                  }
                }
                if (whichFilter.contains(true)) {
                  List<String> selectedFilters = [];
                  for (int i = 0; i < aspectList.selectedArabic.length; i++) {
                    if (whichFilter[i] == true) {
                      selectedFilters.add(aspectList.selectedArabic[i]);
                    }
                  }
                  for (int i = publicCommunities.length - 1; i >= 0; i--) {
                    if (!selectedFilters
                        .contains(publicCommunities[i].aspect)) {
                      publicCommunities.removeAt(i);
                    }
                  }
                }
                //sort accroding to percentagePoints

                final sortedAspects = aspectList.allAspects;
                sortedAspects.sort(
                  (a, b) => b.percentagePoints.compareTo(a.percentagePoints),
                );
                List<Community> TempList = [];
                for (Aspect aspect in sortedAspects) {
                  for (int i = publicCommunities.length - 1; i >= 0; i--) {
                    if (publicCommunities[i].aspect ==
                        getArabicAspectFromEnglish(aspect.name)) {
                      TempList.add(publicCommunities[i]);
                    }
                  }
                }
                // publicCommunities = TempList;
                return publicCommunities.isNotEmpty
                    ? GridView.builder(
                        itemCount: publicCommunities.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (1 / 1.3),
                          crossAxisSpacing: screenWidth(context) * 0.05,
                          mainAxisSpacing: screenHeight(context) * 0.03,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              publicCommunityDetailsPopup(context,
                                  community: publicCommunities[index]);
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 0,
                                          blurRadius: 5,
                                          offset: const Offset(0,
                                              5), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: const Color(0xFFEAEAEF),
                                      border: Border.all(
                                        width: 2.4,
                                        color: const Color(0xFFD4D4DE),
                                      ),
                                      image: const DecorationImage(
                                          image: NetworkImage(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcnTCrjKmRCJDwebeZdr5iVQ_9QFHwtLEJsQ&usqp=CAU',
                                          ),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight(context) * 0.02,
                                ),
                                txt(
                                  txt: publicCommunities[index]
                                      .communityName
                                      .toString(),
                                  fontColor: const Color(0xFF7CB1D1),
                                  letterSpacing: 0.0015,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 100),
                          child: Text("لا يوجد مجتمعات"),
                        ),
                      );
              } else {
                return const Center(
                  child: Text("لا يوجد مجتمعات"),
                );
              }
            })),
      ],
    ));
  }

  String getArabicAspectFromEnglish(String english) {
    switch (english) {
      case "money and finances":
        return "أموالي";
      case "Fun and Recreation":
        return "متعتي";
      case "career":
        return "مهنتي";
      case "Significant Other":
        return "علاقاتي";
      case "Physical Environment":
        return "بيئتي";
      case "Personal Growth":
        return "ذاتي";
      case "Health and Wellbeing":
        return "صحتي";
      case "Family and Friends":
        return "عائلتي وأصدقائي";
    }
    return '';
  }

  Container communityScreenTabContainer(
    BuildContext context, {
    required String text,
    required Color color,
  }) {
    return Container(
      width: screenWidth(context) * 0.4,
      height: screenHeight(context) * 0.05,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(4.0),
        ),
        color: color,
      ),
      child:
          Center(child: txt(txt: text, fontSize: 14, fontColor: Colors.white)),
    );
  }
}

Widget CommunityTile(final community, final currentUserFounderName) {
  return Expanded(
    child: ListView.builder(
        itemCount: community.length,
        itemBuilder: (context, index) {
          String goalname = community[index].goalName;
          String CommunityAspect = community[index].aspect;
          var aspectList = Provider.of<WheelData>(context);
          List<Aspect> listOfaspect = aspectList.selected;
          int selsectAspectIndex = 0;
          for (int i = 0; i < listOfaspect.length; i++) {
            if (listOfaspect[i].name == CommunityAspect) {
              selsectAspectIndex = i;
            }
          }

          Icon aspectIcon = Icon(
            IconData(
              aspectList.selected[selsectAspectIndex].iconCodePoint,
              fontFamily:
                  aspectList.selected[selsectAspectIndex].iconFontFamily,
              fontPackage:
                  aspectList.selected[selsectAspectIndex].iconFontPackage,
              matchTextDirection:
                  aspectList.selected[selsectAspectIndex].iconDirection,
            ),
          );
          Color aspectColor =
              Color(aspectList.selected[selsectAspectIndex].color);
          //switch to get the icon .
          //      switch (CommunityAspect) {
          //   //Must include all the aspect characters and specify an icon for that
          //   case "Health and Wellbeing":
          //     {
          //       // statements;
          //       aspectIcon = Icon(Icons.spa);
          //       aspectColor= Color(0xFFffd400);
          //     }
          //     break;

          //   case "career":
          //     {
          //       //statements;
          //       aspectIcon=Icon(Icons.work);
          //       aspectColor=Color(0xff0065A3);
          //     }
          //     break;
          //   case "Family and Friends":
          //     {
          //       //statements;
          //       aspectIcon=Icon(Icons.person);
          //       aspectColor=Color(0xFFff9100);
          //     }
          //     break;

          //   case "Significant Other":
          //     {
          //       //statements;
          //       aspectIcon =Icon(
          //         Icons.favorite,
          //        );
          //        aspectColor= Color(0xffff4949);

          //     }
          //     break;
          //   case "Physical Environment":
          //     {
          //       //statements;
          //      aspectIcon=Icon(
          //         Icons.home,
          //       );
          //       aspectColor=Color(0xFF9E19F0);
          //     }
          //     break;
          //   case "money and finances":
          //     {
          //       //statements;
          //      aspectIcon= Icon(
          //         Icons.attach_money,
          //       );
          //       aspectColor=Color(0xff54e360);
          //     }
          //     break;
          //   case "Personal Growth":
          //     {
          //       //statements;
          //       aspectIcon= Icon(
          //         Icons.psychology,
          //       );
          //       aspectColor= Color(0xFF2CDDCB);
          //     }
          //     break;
          //   case "Fun and Recreation":
          //     {
          //       //statements;
          //       aspectIcon= Icon(
          //         Icons.games,
          //       );
          //       aspectColor = Color(0xff008adf);
          //     }
          //     break;
          // }

          //switch to get the colors .

          bool isAdmin =
              community[index].founderUsername == currentUserFounderName;
          return GestureDetector(
            onTap: (() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommunityHomePage(
                            comm: community[index],
                          )));
            }),
            child: ListTile(
              leading: Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: aspectColor,
                ),
                alignment: Alignment.center,
                child: Icon(
                  aspectIcon.icon,
                  color: Colors.white,
                ),
              ),
              subtitle: Text('  الهدف : $goalname'),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    community[index].communityName ?? '',
                    style: const TextStyle(
                      color: kBlackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Icon(
                    community[index].isPrivate! ? Icons.lock : Icons.people,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    isAdmin ? 'مشرف' : 'منضم',
                    style: const TextStyle(
                      color: kBlackColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
  );
}
