import 'package:flutter/material.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/homepage/daily_tasks/display_list.dart';
import '/data/data.dart';
import 'wheel_of_life/pie_chart_page.dart';
import 'wheel_of_life/renderWheelSections.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<Homepage> {
//progress Widget

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    double imageHeight = height * 0.5;
    return StreamBuilder(
      stream: IsarService().getSelectedAspectsStream(),
/////////////////////start of stream builder for aspects///////////////////////////////
      builder: (context, snapshot) {
        //create empty incase
        List<Aspect>? aspects = [];
        //check if there are goals (check for habits later)
        if (snapshot.hasData) {
          aspects = snapshot.data;
          //add habits to list later
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //displays the visualization (wheel of life)
              Stack(alignment: Alignment.center, children: [
                createCentralcircules(
                  10,
                ),
                createCentralcircules(
                  20,
                ),
                createCentralcircules(
                  30,
                ),
                createCentralcircules(
                  40,
                ),
                createCentralcircules(
                  50,
                ),
                createCentralcircules(
                  60,
                ),
                createCentralcircules(
                  70,
                ),
                createCentralcircules(
                  80,
                ),
                Container(
                  margin: const EdgeInsets.all(0.0),
                  height: imageHeight,
                  child: const WheelBackground(),
                ),
                life_wheel(allAspects: aspects??[]),
              ]),
              // displays the daily tasks list
              Flexible(
                child: Center(
                  child: TodoCard(
                    todo: createTodoList(aspects??[]),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //displays the visualization (wheel of life)
              Stack(alignment: Alignment.center, children: [
                Container(
                  margin: const EdgeInsets.all(0.0),
                  height: imageHeight,
                  child: const WheelBackground(),
                ),
                life_wheel(
                  allAspects: aspects,
                ),
              ]),
              // displays the daily tasks list
              const Flexible(
                child: Center(
                  child: TodoCard(
                    todo: emptyTasks,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
