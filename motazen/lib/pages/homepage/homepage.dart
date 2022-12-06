import 'package:flutter/material.dart';
import 'package:motazen/pages/select_aspectPage/handle_aspect_data.dart';
import 'package:provider/provider.dart';
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
                  image: AssetImage('assets/images/wheelHome.png'),
                  fit: BoxFit.contain),
            ),
          ),
          const life_wheel(),
        ]),

        // displays the daily tasks list
        Flexible(
          child: Center(
            child: TodoCard(
              todo: fakeData,
            ),
          ),
        ),
      ],
    );
  }
}
