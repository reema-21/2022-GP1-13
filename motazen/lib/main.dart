import 'dart:io';

import 'package:motazen/data/data.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/habit.dart';
import 'package:motazen/goals_habits_tab/goal_habits_pages.dart';
import 'package:motazen/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/select_aspectPage/fetch_all_aspects.dart';
import 'package:provider/provider.dart';

import 'assesment_page/show.dart';
import 'entities/goal.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    if (Platform.isIOS) {
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    } else {
      await Firebase.initializeApp();
    } // to inizlize the db
  } else {
    Firebase.app(); // if already initialized, use that one
  }
  IsarService iser = IsarService(); // inislize the local storage

  iser.openIsar();
  Aspect career = Aspect();
  career.name = "career";
  career.percentagePoints = 0;
  iser.createAspect(career);

  Aspect health = Aspect();
  health.name = "Health and Wellbeing";
  health.percentagePoints = 0;
  iser.createAspect(health);

  Goal x = Goal();
  Aspect? y = await iser.findSepecificAspect("career");
  x.aspect.value = y;
  x.dueDate = DateTime.utc(1989, 11, 9);
  x.duration = "3 days";
  x.goalDuration = "ds";
  x.titel = "اركض ";
  x.importance = 1;
  x.goalDuration = "3month";
  x.goalDependency.value = x;

  iser.createGoal(x);

  Habit yi = Habit();
  yi.aspect.value = y;
  yi.titel = "صحتي هي حياتي ";
  yi.frequency = "3 times a day ";
  iser.createHabit(yi);
  Habit ji = Habit();
  Aspect? k = await iser.findSepecificAspect("Health and Wellbeing");

  ji.aspect.value = k;
  ji.titel = "صحتي هي rgfd حياتي ";
  ji.frequency = "3 times a day ";
  iser.createHabit(ji);

  runApp(ChangeNotifierProvider<WheelData>(
      create: (_) => WheelData(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: fetchAspect(
              iser:
                  iser)))); // my widget // the one where i will create the quastion list .
}
