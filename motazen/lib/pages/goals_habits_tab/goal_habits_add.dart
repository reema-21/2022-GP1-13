// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import '../add_habit_page/get_chosed_aspect.dart';
import '/isar_service.dart';
import '../../Sidebar_and_navigation/navigation-bar.dart';
import '../add_goal_page/get_chosen_aspect.dart';
import 'goal_habits_pages.dart';

class Goals_habit_add extends StatefulWidget {
  final IsarService iser;

  const Goals_habit_add({super.key, required this.iser});

  @override
  State<Goals_habit_add> createState() => Goals_habitState();
}

class Goals_habitState extends State<Goals_habit_add> {
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
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Goals_habit(iser: widget.iser);
                      }));
                    })
              ],
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
                        child: Text("إضافة هدف",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500))), //Goals page
                    Tab(
                        child: Text("إضافة عادة",
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
                    getChosenAspect(
                      iser: widget.iser,
                      page: 'Goal',
                    ),
                    //second
                    getChosenAspectH(iser: widget.iser)
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
