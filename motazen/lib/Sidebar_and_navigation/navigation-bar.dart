// ignore_for_file: file_names, camel_case_types

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:motazen/pages/homepage/homepage.dart';
import 'package:motazen/theme.dart';
import '../pages/add_goal_page/get_chosen_aspect.dart';
import '../pages/add_habit_page/get_chosed_aspect.dart';
import '../pages/communities_page/comming-soon(community).dart';
import '../pages/journal_page/commin-soon(journal).dart';
import '/pages/goals_habits_tab/goal_habits_pages.dart';
import '/isar_service.dart';
import 'sidebar.dart';

///add page redirection later
///
class navBar extends StatefulWidget {
  const navBar({super.key});

  @override
  State<navBar> createState() => _MynavBar();
}

class _MynavBar extends State<navBar> {
  int selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const Homepage(),
    Goals_habit(iser: IsarService()),
    const Communities(),
    const Journal(),
  ];

  @override
  Widget build(BuildContext context) {
    navigate(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        //show the controller if the goals and habits tab is selected
        length: selectedIndex == 1 ? 2 : 1,
        child: Scaffold(
          appBar: AppBar(
              // notifications button
              backgroundColor: kWhiteColor,
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 0.0,
              actions: <Widget>[
                const IconButton(
                    onPressed: null,
                    icon: Icon(
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
                                return Center(
                                  child: AlertDialog(
                                      title: const Text(
                                        "أود إضافة ",
                                      ),
                                      content: Row(children: [
                                        TextButton(
                                          child: const Text("هدف"),
                                          onPressed: () {
                                            Get.to(() => getChosenAspect(
                                                  iser: IsarService(),
                                                  goalsTasks: const [],
                                                  page: 'Goal',
                                                ));
                                          },
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        TextButton(
                                          child: const Text("عادة"),
                                          onPressed: () {
                                            Get.to(() => getChosenAspectH(
                                                  iser: IsarService(),
                                                ));
                                          },
                                        ),
                                      ])),
                                );
                              });
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
                              child: Text("أهدافي",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.w500))), //Goals page
                          Tab(
                              child: Text("عاداتي",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.w500))) //habits page
                        ])
                  : const PreferredSize(
                      preferredSize: Size(0, 0), child: SizedBox())),
          drawer: const SideBar(),
          backgroundColor: kWhiteColor,
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
                    text: 'الرئسية',
                  ),
                  GButton(
                    icon: LineIcons.check, //click here move me to a page
                    text: 'عاداتي وأهدافي',
                  ),
                  GButton(
                    icon: LineIcons.peopleCarry,
                    text: 'مجتمعاتي',
                  ),
                  GButton(
                    icon: LineIcons.book,
                    text: 'مذكرتي',
                  ),
                ],
                onTabChange: navigate,
                selectedIndex: selectedIndex,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
