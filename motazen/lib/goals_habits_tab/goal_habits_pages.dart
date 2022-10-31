import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:motazen/goals_habits_tab/goal_list_screen.dart';
import 'package:motazen/isar_service.dart';
import "package:motazen/pages/homepage/homepage.dart";
import '../Sidebar_and_navigation/navigation-bar.dart';
import '../add_goal_page/add_goal_screen.dart';
import '../add_goal_page/get_chosen_aspect.dart';
import 'habit_list_screen.dart';

// ignore: camel_case_types
class Goals_habit extends StatefulWidget {
  final IsarService isr;

   const Goals_habit({super.key, required this.isr});

  @override
  State<Goals_habit> createState() => Goals_habitState();
}

class Goals_habitState extends State<Goals_habit> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
          length: 2,
          child: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  actions: [ GestureDetector(
                  child: const Icon(Icons.add, color: Colors.black12, size: 30),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return  getChosenAspect(iser: widget.isr);// must be the
                    }));
                  },
                )],
                  backgroundColor: Colors.white,
                   iconTheme: const IconThemeData(color: Colors.black),
                  elevation: 0.0,
                 
                  bottom:   TabBar( isScrollable: true,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
                   labelPadding: const EdgeInsets.symmetric(horizontal:70),
                   indicatorPadding: const EdgeInsets.symmetric(horizontal: 25),
                
            indicator: new BubbleTabIndicator(
              indicatorHeight:  35.0,
              indicatorColor:  const Color(0xFF66BF77),
              tabBarIndicatorSize:  TabBarIndicatorSize.tab,
              
                    
            ),  
                    
                    // ignore: prefer_const_literals_to_create_immutables
                    tabs: [
                       // ignore: prefer_const_constructors
                       Tab(
                       child: const Text("أهدافي" ,style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
                        
                        
                      ), //Goals page
                       const Tab(
                                             child: Text("عاداتي" ,style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
          
                         )  //habits page
                    ]),
                ),
                body: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children:  [
                     Expanded(
                      child: TabBarView(
                        children: [
                          //firstTap
                       GoalListScreen(isr: widget.isr),
                       //second
                       HabitListScreen(isr:widget.isr)
                    
                    
                      ]),
                    )
                  ],
                ),
                
                ),
          ),
        ),
      ),
    );
  }
}
