import 'dart:io';

<<<<<<< Updated upstream
import 'package:motazen/pages/onboarding_page.dart';

import '/data/data.dart';
import '/isar_service.dart';
=======
import 'package:motazen/add_goal_page/get_chosen_aspect.dart';

import 'package:motazen/data/data.dart';
import 'package:motazen/entities/aspect.dart';

import 'package:motazen/isar_service.dart';
>>>>>>> Stashed changes
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

<<<<<<< Updated upstream
=======
import 'add_goal_page/add_goal_screen.dart';
import 'entities/goal.dart';
import 'entities/task.dart';
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
  // Aspect career = Aspect();
  // career.name = "Health and Wellbeing";
  // career.percentagePoints = 89;
  // career.color = 0 ;
  // career.isSelected = false;
  //   career .iconFontFamily="sdf";
  //   career.iconFontPackage="jjj";
  //     career.iconCodePoint=0;
  // career.iconDirection=false;
=======
  Aspect career = Aspect();
  career.name = "Health and Wellbeing";
  career.percentagePoints = 89;
  career.color = 0 ; 
  career.isSelected = false;
    career .iconFontFamily="sdf";
    career.iconFontPackage="jjj";
      career.iconCodePoint=0;
  career.iconDirection=false;
>>>>>>> Stashed changes

  // iser.createAspect(career);

  // Aspect health = Aspect();
  // health.name = "Health and Wellbeing";
  // health.percentagePoints = 99;
  // health.color = 0 ;
  // health.isSelected = false;
  // health.iconFontFamily="sdf";
  // health.iconFontPackage="sfasdfa";
  // health.iconCodePoint=0;
  // health.iconDirection=false;
  // iser.createAspect(health);

   Goal x = Goal();
   Aspect? y = await iser.findSepecificAspect("Health and Wellbeing");
   x.aspect.value = y;
  // x.dueDate = DateTime.utc(1989, 11, 9);
  // x.DescriptiveGoalDuration = "فضلاَ،اختر الطريقة الأمثل لحساب فترةالهدف من الأسفل";
  // x.goalDuration = 0;
  // x.titel = "اركض ";
  // x.importance = 0;
  // x.goalDependency.value = x;

  // iser.createGoal(x);
  // Task a = Task();
  // a.duration = 5 ;
  // a.name = "hi";
  // a.goal.value = x;
  // x.task.value = a ;
  // x.task.save;
  // iser.saveTask(a);
  

  // Habit yi = Habit();
  // yi.aspect.value = y;
  // yi.titel = "صحتي هي حياتي ";
  // yi.frequency = "3 times a day ";
  // iser.createHabit(yi);
  // Habit ji = Habit();
  // Aspect? k = await iser.findSepecificAspect("Health and Wellbeing");

  // ji.aspect.value = k;
  // ji.titel = "صحتي هي rgfd حياتي ";
  // ji.frequency = "3 times a day ";
  // iser.createHabit(ji);
  runApp(ChangeNotifierProvider<WheelData>(
      create: (_) => WheelData(),
      child: const MaterialApp(
          debugShowCheckedModeBanner: false,
<<<<<<< Updated upstream
          home:
              OnboardingPage()))); // my widget // the one where i will create the quastion list .
=======
          home:getChosenAspect(iser: iser, goalsTasks: [], 
              )))); // my widget // the one where i will create the quastion list .
>>>>>>> Stashed changes
}
