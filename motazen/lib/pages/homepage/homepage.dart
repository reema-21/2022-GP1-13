import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/homepage/daily_tasks/display_list.dart';
import 'wheel_of_life/pie_chart_page.dart';
import 'wheel_of_life/render_wheel_sections.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);
  @override
  State<Homepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    // Get the height and width of the screen
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // Calculate the height of the wheel image
    double imageHeight = height * 0.5;

    // Build the UI based on the selected aspects stream
    return StreamBuilder<List<Aspect>>(
      stream: IsarService().getSelectedAspectsStream(),
      builder: (context, snapshot) {
        // Create an empty list of aspects as a fallback
        List<Aspect> aspects = [];
        if (snapshot.hasData) {
          // Use the list of selected aspects from the stream if available
          aspects = snapshot.data!;
        }

        // Build the UI
        return DefaultTabController(
          length: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Display the visualization (wheel of life)
              Stack(
                alignment: Alignment.center,
                children: [
                  for (double i = 8; i <= 68; i += 10) createCentralcircles(i),
                  SizedBox(
                    height: imageHeight,
                    width: width,
                    child: const WheelBackground(),
                  ),
                  LifeWheel(allAspects: aspects),
                ],
              ),

              // Display the daily tasks list
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
                  ],
                ),
              ),

              // Display the daily tasks list
              Flexible(
                child: TabBarView(
                  children: [
                    const TaskTodoCard(),
                    HabitTodoCard(aspectList: aspects),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
