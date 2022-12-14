// ignore_for_file: file_names, camel_case_types

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/communities_page/create_community.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/community_controller.dart';
import '../data/data.dart';
import '../pages/add_goal_page/get_chosen_aspect.dart';
import '../pages/add_goal_page/task_controller.dart';
import '../pages/add_habit_page/add_habit.dart';
import '../pages/communities_page/communities.dart';
import '../pages/goals_habits_tab/goal_habits_pages.dart';
import '../pages/homepage/homepage.dart';
import '../pages/journal_page/commin-soonjournal.dart';
import '../pages/notifications_screen.dart/notifications_screen.dart';
import 'sidebar.dart';

class navBar extends StatefulWidget {
  final int selectedIndex;
  const navBar({super.key, required this.selectedIndex});

  @override
  State<navBar> createState() => _MynavBar();
}

class _MynavBar extends State<navBar> {
  late int selectedIndex;
  AuthController authController = Get.put(AuthController());
  CommunityController communityController = Get.put(CommunityController());
  TaskControleer taskControleer = Get.put(TaskControleer());

  final List<Widget> _widgetOptions = [
    const Homepage(),
    Goals_habit(iser: IsarService()),
    const Communities(),
    const Journal(),
  ];
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
    authController.getUsersList();
    communityController.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<WheelData>(context);
    navigate(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return DefaultTabController(
      //show the controller if the goals and habits tab is selected
      length: selectedIndex == 1 ? 2 : 1,
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
            // notifications button
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Get.to(const NotificationsScreen());
                  },
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  tooltip: 'View Requests'),
              selectedIndex == 1
                  ? IconButton(
                      icon: const Icon(Icons.add, color: kBlackColor),
                      iconSize: 30,
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text(
                                    "?????? ?????????? ",
                                    textAlign: TextAlign.center,
                                    style: subTitle,
                                  ),
                                  content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          child: Text(
                                            "??????",
                                            style: alertText,
                                          ),
                                          onPressed: () {
                                            Get.to(() => getChosenAspect(
                                                  iser: IsarService(),
                                                  page: 'Goal',
                                                  origin: '',
                                                ));
                                          },
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        TextButton(
                                          child: Text(
                                            "????????",
                                            style: alertText,
                                          ),
                                          onPressed: () {
                                            Get.to(() => AddHabit(
                                                  isr: IsarService(),
                                                  chosenAspectNames:
                                                      aspectList.selectedArabic,
                                                ));
                                          },
                                        ),
                                      ]));
                            });
                      },
                    )
                  : selectedIndex == 2
                      ? IconButton(
                          icon: const Icon(Icons.add, color: kBlackColor),
                          iconSize: 30,
                          onPressed: () async {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const CreateCommunity();
                            }));
                          },
                        )
                      : const SizedBox(
                          height: 0,
                          width: 0,
                        ),
            ],
            bottom: selectedIndex == 1
                ? const TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.symmetric(horizontal: 70),
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 25),
                    indicator: BubbleTabIndicator(
                      indicatorHeight: 35.0,
                      indicatorColor: Color(0xFF66BF77),
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                    tabs: [
                        Tab(
                            child: Text("????????????",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500))), //Goals page
                        Tab(
                            child: Text("????????????",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500))) //habits page
                      ])
                : const PreferredSize(
                    preferredSize: Size(0, 0), child: SizedBox())),
        drawer: const SideBar(),
        body: SafeArea(child: _widgetOptions[selectedIndex]),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(width: 0.5, color: Colors.grey.shade300),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
            child: GNav(
              gap: 8, // the tab button gap between icon and text
              color: kBlackColor, // unselected icon color
              activeColor: kWhiteColor, // selected icon and text color
              iconSize: 24, // tab button icon size
              tabBackgroundColor:
                  kPrimaryColor, // selected tab background color
              padding: const EdgeInsets.all(16.0), // navigation bar padding
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: '??????????????',
                ),
                GButton(
                  icon: LineIcons.check, //click here move me to a page
                  text: '???????????? ??????????????',
                ),
                GButton(
                  icon: LineIcons.peopleCarry,
                  text: '????????????????',
                ),
                GButton(
                  icon: LineIcons.book,
                  text: '????????????',
                ),
              ],
              onTabChange: navigate,
              selectedIndex: selectedIndex,
            ),
          ),
        ),
      ),
    );
  }
}
