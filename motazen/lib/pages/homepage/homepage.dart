import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/homepage/daily_tasks/create_list.dart';
import 'package:motazen/pages/homepage/daily_tasks/display_list.dart';
import 'package:provider/provider.dart';
import 'wheel_of_life/pie_chart_page.dart';
import 'wheel_of_life/renderWheelSections.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var selectedAspects = Provider.of<AspectController>(context).selected;
    double imageHeight = height * 0.5;
    //add habits to list later
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //displays the visualization (wheel of life)
          StreamBuilder(
            stream: IsarService().getSelectedAspectsStream(),
            builder: (context, snapshot) {
              //create empty incase
              List<Aspect>? aspects = [];
              if (snapshot.hasData) {
                aspects = snapshot.data;
                return Stack(alignment: Alignment.center, children: [
                  createCentralcircules(
                    8,
                  ),
                  createCentralcircules(
                    18,
                  ),
                  createCentralcircules(
                    28,
                  ),
                  createCentralcircules(
                    38,
                  ),
                  createCentralcircules(
                    48,
                  ),
                  createCentralcircules(
                    58,
                  ),
                  createCentralcircules(
                    68,
                  ),
                  Container(
                    margin: const EdgeInsets.all(0.0),
                    height: imageHeight,
                    child: const WheelBackground(),
                  ),
                  life_wheel(allAspects: aspects ?? []),
                ]);
              } else {
                //TODO: add circular shimmer effect
                return const CircularProgressIndicator.adaptive();
              }
            },
          ),
          // displays the daily tasks list
          const Center(
            child: TabBar(
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
                    child: Text("مهامي"),
                  ),
                  Tab(
                    child: Text("عاداتي"),
                  ),
                ]),
          ),

          Flexible(
            child: Center(
              child: TabBarView(children: [
                TaskTodoCard(todo: createTaskTodoList(selectedAspects)),
                HabitTodoCard(
                    daysTodo: createHabitDailyTodoList(selectedAspects),
                    monthsTodo: createHabitMonthlyTodoList(selectedAspects),
                    weeksTodo: createHabitWeeklyTodoList(selectedAspects),
                    yearsTodo: createHabitYearlyTodoList(selectedAspects))
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
