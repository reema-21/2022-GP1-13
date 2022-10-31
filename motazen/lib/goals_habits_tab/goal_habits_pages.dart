import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:motazen/goals_habits_tab/goal_list_screen.dart';
import 'package:motazen/isar_service.dart';
import "package:motazen/pages/homepage/homepage.dart";
import '../Sidebar_and_navigation/navigation-bar.dart';
import 'habit_list_screen.dart';

// ignore: camel_case_types
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
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
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
