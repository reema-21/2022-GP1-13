import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:motazen/Sidebar_and_navigation/expandable_fab.dart';
import 'package:motazen/controllers/notification_controller.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/notifications_screen.dart/notifications_screen.dart';
import 'package:motazen/pages/add_goal_page/add_goal_screen.dart';
import 'package:motazen/pages/communities_page/list%20of%20communities/create_community.dart';
import 'package:motazen/pages/goals_habits_tab/goal_habits_pages.dart';
import 'package:motazen/pages/homepage/homepage.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/community_controller.dart';
import '../controllers/aspect_controller.dart';
import '../controllers/task_controller.dart';
import '../pages/add_habit_page/add_habit.dart';
import '../pages/communities_page/list of Communities/Communities.dart';
import '../pages/journal_page/journal_screen.dart';
import 'sidebar.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;
  final List<String> selectedNames;
  const NavBar(
      {super.key, required this.selectedIndex, required this.selectedNames});

  @override
  State<NavBar> createState() => _MynavBar();
}

class _MynavBar extends State<NavBar> {
  late int selectedIndex;
  int numOfNotifications = 0;
  final NotificationController _notificationController =
      NotificationController();
  final List<Widget> _widgetOptions = [
    const Homepage(),
    GoalsHabit(iser: IsarService()),
    const Communities(),
    Journal(),
  ];

  AuthController authController = Get.put(AuthController());
  TaskControleer taskControleer = Get.put(TaskControleer());

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
    authController.getUsersList();
    authController.getUserAvatar();
    _listenToNotifications();
  }

  @override
  void dispose() {
    _notificationController.cancelNotificationsSubscription();
    super.dispose();
  }

  void _listenToNotifications() {
    _notificationController.listenToNotifications(widget.selectedNames);
    _notificationController.notificationsStream.listen((notifications) {
      setState(() {
        numOfNotifications = notifications.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
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
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
        floatingActionButton: selectedIndex == 1 || selectedIndex == 2
            ? selectedIndex == 1
                ? ExpandableFab(
                    distance: 75.0,
                    children: [
                      ActionButton(
                        onPressed: () => Get.to(() =>
                            AddGoal(isr: IsarService(), goalsTasks: const [])),
                        icon: const Icon(Icons.sports_score),
                      ),
                      ActionButton(
                        onPressed: () => Get.to(() => AddHabit(
                              isr: IsarService(),
                            )),
                        icon: const Icon(Icons.event_repeat),
                      ),
                    ],
                  )
                : SizedBox(
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const CreateCommunity();
                        }));
                      },
                      backgroundColor: kPrimaryColor,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  )
            : null,

        appBar: AppBar(
            // notifications button
            elevation: 0.0,
            actions: <Widget>[
              InkWell(
                onTap: (() {
                  Get.to(() => NotificationsScreen(
                        selectedAspects: aspectList.getSelectedNames(),
                      ));
                }),
                child: SizedBox(
                  width: 72,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.notifications,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      numOfNotifications > 0
                          ? Positioned(
                              top: -1,
                              right: 7,
                              child: Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    numOfNotifications.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ))
                          : const SizedBox(),
                    ],
                  ),
                ),
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
                                    fontWeight: FontWeight.w500))), //Goals page
                        Tab(
                            child: Text("عاداتي",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500))) //habits page
                      ])
                : const PreferredSize(
                    preferredSize: Size(0, 0), child: SizedBox())),

        /// drawer
        drawer: const SideBar(),

        /// body
        body: SafeArea(child: _widgetOptions[selectedIndex]),

        /// bottom nav bar
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
    );
  }
}
