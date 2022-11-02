import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:motazen/add_goal_page/add_goal_screen.dart';
import 'package:motazen/add_habit_page/add_habit.dart';
import 'package:motazen/goals_habits_tab/goal_habits_add.dart';
import 'package:motazen/goals_habits_tab/goal_list_screen.dart';
import 'package:motazen/isar_service.dart';
import '../Sidebar_and_navigation/navigation-bar.dart';
import '../add_goal_page/get_chosen_aspect.dart';
import '../assesment_page/aler2.dart';
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
          
              actions:  [
            IconButton(
                // ignore: prefer_const_constructors
                icon: Icon(Icons.plus_one,
                    color: const Color.fromARGB(255, 245, 241, 241)),
                onPressed: () async {
                  final action = await AlertDialogs.yesCancelDialog(
                      context,
               '',
                   'هل تريد اضافة :');
                  if (action == DialogsAction.yes) {
                    //return to the previouse page different code for the ios .
                    Navigator.push(context, MaterialPageRoute(builder: (context) {return AddGoal(isr: widget.iser,);}));
                  } else {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {return AddHabit(isr: widget.iser,);}));

                  }
                }),
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
