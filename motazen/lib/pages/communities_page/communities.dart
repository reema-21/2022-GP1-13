import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/pages/communities_page/community_home.dart';
import 'package:motazen/theme.dart';
import 'package:motazen/widget/greenContainer.dart';

import '../../models/community.dart';

class Communities extends StatefulWidget {
  const Communities({super.key});

  @override
  State<Communities> createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  bool isSearchCommunitySelected = false;
  bool isMyCommunitySelected = true;
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
                        text: 'البحث عن مجتمعات'),
                  ),
                ],
              ),
              Container(
                width: screenWidth(context),
                height: 1,
                color: Colors.grey.shade300,
              ),
              isSearchCommunitySelected
                  ? searchCommunitiesSelectedContainer(context)
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
                ? communtiesGrid(context,
                    listOfCommunities:
                        communityController.listOfCreatedCommunities)
                : communtiesGrid(context,
                    listOfCommunities:
                        communityController.listOfJoinedCommunities)
          ],
        );
      }),
    );
  }

  Expanded communtiesGrid(BuildContext context,
      {required List<Community> listOfCommunities}) {
    return Expanded(
      child: GridView.builder(
        itemCount: listOfCommunities.length,
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommunityHomePage(
                          comm: listOfCommunities[index],
                        )),
              );
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
                          offset:
                              const Offset(0, 5), // changes position of shadow
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
                  txt: listOfCommunities[index].communityName.toString(),
                  fontColor: const Color(0xFF7CB1D1),
                  letterSpacing: 0.0015,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Column searchCommunitiesSelectedContainer(BuildContext context) {
    return Column(
      children: const [],
    );
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
