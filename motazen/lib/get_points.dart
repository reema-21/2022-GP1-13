import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:motazen/data/data.dart';
import 'package:motazen/data/models.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/homepage/homepage.dart';
import 'package:motazen/pages/homepage/wheel_of_life/pie_chart_page.dart';

import 'assesment_page/assesment_question_page_assignments.dart';
import 'entities/aspect.dart';

class GetPoints extends StatefulWidget {
  final IsarService isr;
  final List<Aspect> aspects;
  const GetPoints({super.key, required this.isr, required this.aspects});

  @override
  State<GetPoints> createState() => _GetPointsState();
}

class _GetPointsState extends State<GetPoints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: IsarService().getpointsAspects(widget
                .aspects), // do not forget to sended it when using it in the stepper widget
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map? points = snapshot.data;
                List<Data> dataList = [];
                String name;
                double point;
                 Color color=const Color(0xFFff9100);
                 Widget icon= const Icon(Icons.person);
                points!.forEach((k,v) {
                  name = k ;
                  point=v ;
                  switch (name) {
        case "money and finances":
        color=const Color(0xff54e360);
        icon=const Icon(Icons.attach_money);
         
          break;
        case "Fun and Recreation":
          color= const Color(0xff008adf);
        icon=const Icon(Icons.games);
          break;
        case "career":
         color=Color.fromARGB(255, 163, 0, 35); //fix colors
         icon=const Icon(Icons.work);
          break;
        case "Significant Other":
           color= const Color(0xffff4949);
        icon=const Icon(Icons.work);//fix
          break;
        case "Physical Environment":
          color= const Color(0xFF9E19F0);
        icon= const Icon(Icons.work);//fix
          break;
        case "Personal Growth":
          color= const Color(0xFF2CDDCB);
        icon=const Icon(Icons.work);//fix
          break;

        case "Health and Wellbeing":
         color= const Color(0xFFffd400);
         icon=const Icon(Icons.health_and_safety); //
          break;
        case "Family and Friends":
        color=const Color(0xFFff9100);
        icon=const Icon(Icons.person);
         
          break;
          
                  }

   dataList.add(Data(
                    name:name,
                    points:point,
                    color:color,
                    icon: icon));
                }); 
              print ("here is the data list");
              print(dataList[0].name);
                return Homepage(dataList: dataList);
              } else {
                return CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
