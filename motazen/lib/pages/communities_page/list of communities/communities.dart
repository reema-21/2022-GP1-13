import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/pages/communities_page/community/community_home.dart';
import 'package:motazen/pages/communities_page/list%20of%20communities/public_community_popup.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import '../../../controllers/aspect_controller.dart';
import '../../../entities/aspect.dart';
import '../../../models/community.dart';

//DONENOW
//ours
class Communities extends StatefulWidget {
  const Communities({super.key});

  @override
  State<Communities> createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  bool isSearchCommunitySelected = false;
  bool isMyCommunitySelected = true;
  bool isFilterClicked = false;
  List<Community> userCommunities = [];
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

  // we target on listOfCreatedCommunities, listOfCreatedCommunities + listOfJoinedCommunities
  CommunityController communityController = Get.find();

  @override
  void initState() {
    userDataUpdate();
    super.initState();
  }

  Future<void> userDataUpdate() async {
    await communityController.getUserData();
    userCommunities = communityController.listOfCreatedCommunities +
        communityController.listOfJoinedCommunities;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kWhiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'المجتمعات',
              style: titleText,
            ),
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
                          text: 'مجتمعاتي'),
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: communityScreenTabContainer(context,
                            color: isSearchCommunitySelected
                                ? kPrimaryColor
                                : kPrimaryColor.withOpacity(0.5),
                            text: 'المجتمعات العامة'),
                      ),
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
      ),
    );
  }

  Expanded myCommunitiesSelectedContainer(BuildContext context) {
    return Expanded(
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            SizedBox(
              height: screenHeight(context) * 0.01,
            ),
            communityTile(userCommunities, firebaseAuth.currentUser!.uid)
          ],
        );
      }),
    );
  }

  Expanded publicCommuntiesGrid(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Row(
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
                  child: const Text('تصفية'))
            ],
          ),
          if (isFilterClicked)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: aspectList.selected.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
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
                        border: Border.all(
                            color: Color(aspectList.selected[index].color)),
                        color: whichFilter[index]
                            ? Color(aspectList.selected[index].color)
                                .withOpacity(0.8)
                            : Colors.white,
                      ),
                      child: Center(
                          child: Text(
                        aspectList.selected[index].name,
                        style: TextStyle(
                            color:
                                whichFilter[index] ? kWhiteColor : kBlackColor,
                            fontSize: 16),
                        overflow: TextOverflow.visible,
                      )),
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
                    if (!(communityController.listOfJoinedCommunities
                                    .indexWhere((element) =>
                                        element.id == community['_id']) >=
                                0 ||
                            communityController.listOfCreatedCommunities
                                    .indexWhere((element) =>
                                        element.id == community['_id']) >=
                                0) &&
                        aspectList
                            .getSelectedNames()
                            .contains(community['aspect'])) {
                      publicCommunities.add(Community(
                          progressList: community['progress_list'],
                          aspect: community['aspect'],
                          founderUsername: community['founderUsername'],
                          communityName: community['communityName'],
                          creationDate: community['creationDate'].toDate(),
                          goalName: community['goalName'],
                          isDeleted: community['isDeleted'],
                          isPrivate: community['isPrivate'],
                          id: community['_id']));
                    }
                  }
                  if (whichFilter.contains(true)) {
                    List<String> selectedFilters = [];
                    for (int i = 0; i < aspectList.selected.length; i++) {
                      if (whichFilter[i] == true) {
                        selectedFilters.add(aspectList.selected[i].name);
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
                  List<Community> tempList = [];
                  for (Aspect aspect in sortedAspects) {
                    for (int i = publicCommunities.length - 1; i >= 0; i--) {
                      if (publicCommunities[i].aspect == aspect.name) {
                        tempList.add(publicCommunities[i]);
                      }
                    }
                  }
                  for (int i = publicCommunities.length - 1; i >= 0; i--) {
                    if (publicCommunities[i].isDeleted) {
                      publicCommunities.removeAt(i);
                    }
                  }
                  return publicCommunities.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: publicCommunities.length,
                          itemBuilder: (context, index) {
                            String goalname =
                                publicCommunities[index].goalName!;
                            String communityAspect =
                                publicCommunities[index].aspect!;
                            var aspectList =
                                Provider.of<AspectController>(context);
                            List<Aspect> listOfaspect = aspectList.selected;
                            int selsectAspectIndex = 0;
                            for (int i = 0; i < listOfaspect.length; i++) {
                              if (listOfaspect[i].name == communityAspect) {
                                selsectAspectIndex = i;
                              }
                            }

                            Icon aspectIcon = Icon(
                              IconData(
                                aspectList
                                    .selected[selsectAspectIndex].iconCodePoint,
                                fontFamily: aspectList
                                    .selected[selsectAspectIndex]
                                    .iconFontFamily,
                                fontPackage: aspectList
                                    .selected[selsectAspectIndex]
                                    .iconFontPackage,
                                matchTextDirection: aspectList
                                    .selected[selsectAspectIndex].iconDirection,
                              ),
                            );
                            Color aspectColor = Color(
                                aspectList.selected[selsectAspectIndex].color);
                            publicCommunities[index].founderUsername ==
                                firebaseAuth.currentUser!.displayName;
                            return GestureDetector(
                              onTap: () {
                                publicCommunityDetailsPopup(context,
                                    community: publicCommunities[index]);
                              },
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
                                      publicCommunities[index].communityName ??
                                          '',
                                      style: const TextStyle(
                                        color: kBlackColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    //! uncomment to return the public/private icon and the admin/joind text
                                    // Icon(
                                    //   publicCommunities[index].isPrivate
                                    //       ? Icons.lock
                                    //       : Icons.people,
                                    //   color: Colors.grey[600],
                                    // ),
                                    // const SizedBox(
                                    //   width: 8,
                                    // ),
                                    // Text(
                                    //   isAdmin ? 'مشرف' : 'منضم',
                                    //   style: const TextStyle(
                                    //     color: kBlackColor,
                                    //     fontStyle: FontStyle.italic,
                                    //   ),
                                    // ),
                                  ],
                                ),
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 100),
                      child: Text("لا يوجد مجتمعات"),
                    ),
                  );
                }
              })),
        ],
      ),
    ));
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

Widget communityTile(final community, final currentUserFounderName) {
  return Expanded(
    child: ListView.builder(
        itemCount: community.length,
        itemBuilder: (context, index) {
          String goalname = community[index].goalName;
          String communityAspect = community[index].aspect;
          var aspectList = Provider.of<AspectController>(context);
          List<Aspect> listOfaspect = aspectList.selected;
          int selsectAspectIndex = 0;
          for (int i = 0; i < listOfaspect.length; i++) {
            if (listOfaspect[i].name == communityAspect) {
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

          //switch to get the colors .
          bool isAdmin =
              community[index].founderUsername == currentUserFounderName;
          return GestureDetector(
            onTap: (() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommunityHomePage(
                            fromInvite: false,
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
