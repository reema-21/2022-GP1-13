import 'package:flutter/material.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isarService.dart';
import '/pages/homepage/wheel_of_life/pie_chart_page.dart';
import '/data/data.dart';
import '/pages/homepage/daily_tasks/display_list.dart';

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
      stream: IsarService().getAllAspects(),
/////////////////////start of stream builder for aspects///////////////////////////////
      builder: (context, snapshot1) {
        return StreamBuilder(
            stream: IsarService().getAllGoals(),
/////////////////////start of stream builder for tasks///////////////////////////////
            builder: (context, snapshot2) {
              return StreamBuilder(
                stream: IsarService().getAllHabits(),
/////////////////////start of stream builder for habits///////////////////////////////
                builder: (context, snapshot3) {
                  //create empty incase
                  final List<Aspect> aspects = [];
                  final goals = [];
                  //check if there are goals (check for habits later)
                  if (snapshot2.hasData & snapshot1.hasData) {
                    final goals = snapshot2.data;
                    final aspects = snapshot1.data;
                    //add habits to list later
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        //displays the visualization (wheel of life)
                        Stack(alignment: Alignment.center, children: [
                          Container(
                            margin: const EdgeInsets.all(0.0),
                            height: imageHeight,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/wheelHome.png'),
                                  fit: BoxFit.contain),
                            ),
                          ),
                          life_wheel(allAspects: aspects!),
                        ]),
                        // displays the daily tasks list
                        Flexible(
                          child: Center(
                            child: TodoCard(
                              todo: createTodoList(goals!),
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
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/wheelHome.png'),
                                  fit: BoxFit.contain),
                            ),
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
            });
      },
    );
  }
}
