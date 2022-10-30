import 'package:motazen/data/data.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/habit.dart';
import 'package:motazen/goals_habits_tab/goal_habits_pages.dart';
import 'package:motazen/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:motazen/select_aspectPage/fetch_all_aspects.dart';
import 'package:provider/provider.dart';

import 'entities/goal.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // to inizlize the db
  IsarService iser = IsarService(); // inislize the local storage

  iser.openIsar();
 
Goal x = Goal();
Aspect? y = await iser.findSepecificAspect("career");
x.aspect.value = y ; 
x.dueDate=DateTime.utc(1989, 11, 9);
x.duration= "3 days";
x.goalDuration = "ds";
x.titel="اركض ";
x.importance=1;
x.goalDuration="3month";
x.goalDependency.value = x ; 

iser.createGoal(x);

Habit yi=Habit();
yi.aspect.value = y; 
yi.titel = "صحتي هي حياتي "; 
yi.frequency=  "3 times a day "; 
iser.createHabit(yi);



  runApp(ChangeNotifierProvider<WheelData>(
      create: (_) => WheelData(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Goals_habit(
              isr:
                  iser)))); // my widget // the one where i will create the quastion list .
}
