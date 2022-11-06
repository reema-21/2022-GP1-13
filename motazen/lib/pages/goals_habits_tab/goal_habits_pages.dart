// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import '../add_goal_page/get_chosen_aspect.dart';
import '../add_habit_page/get_chosed_aspect.dart';
import '/pages/goals_habits_tab/goal_list_screen.dart';
import '/isar_service.dart';
import '../../Sidebar_and_navigation/navigation-bar.dart';
import 'habit_list_screen.dart';

class Goals_habit extends StatefulWidget {
  final IsarService iser;

  const Goals_habit({super.key, required this.iser});

  @override
  State<Goals_habit> createState() => Goals_habitState();
}

class Goals_habitState extends State<Goals_habit> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  // ignore: prefer_const_constructors
                  icon: Icon(Icons.add, color: const Color(0xFF66BF77)),
                  iconSize: 40,
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text(
                                "أود إضافة ",
                                textDirection: TextDirection.rtl,
                              ),
                              content: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(children: [
                                  TextButton(
                                    child: const Text("هدف"),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return getChosenAspect(
                                          iser: widget.iser,
                                          goalsTasks: const [],
                                          page: 'Goal',
                                        );
                                      }));
                                    },
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  TextButton(
                                    child: const Text("عادة"),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return getChosenAspectH(
                                          iser: widget.iser,
                                        );
                                      }));
                                    },
                                  ),
                                ]),
                              ));
                        });
                  },
                ),
              ],
              backgroundColor: Colors.white,
              elevation: 0.0,
              bottom: const TabBar(
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

                  // ignore: prefer_const_literals_to_create_immutables
                  tabs: [
                    // ignore: prefer_const_constructors
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
                  ]),
            ),
            body: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Expanded(
                  child: TabBarView(children: [
                    //firstTap
                    GoalListScreen(isr: widget.iser),
                    //second
                    HabitListScreen(isr: widget.iser)
                  ]),
                )
              ],
            ),
            bottomNavigationBar: const navBar(),
          ),
        ),
      ),
    );
  }
}
