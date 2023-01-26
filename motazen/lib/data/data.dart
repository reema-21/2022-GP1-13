// ignore_for_file: await_only_futures, camel_case_types

import 'package:flutter/material.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/isar_service.dart';
import '/entities/aspect.dart';
import 'models.dart';

///create the todo list
Todo createTodoList(List<Aspect> aspectList) {
  //initialize
  List<Item> itemList = [];
  const TimeOfDay resetTime = TimeOfDay(hour: 0, minute: 0);

  //step1: add all tasks and habits to a list
  for (var aspect in aspectList) {
    //retrieve the aspect's goals
    for (var goal in aspect.goals.toList()) {
      //retrive the goal's tasks
      for (var task in goal.task.toList()) {
        itemList.add(Item(
            itemGoal: goal.id,
            id: task.id,
            description: task.name,
            completed: task.completedForToday,
            icon: Icon(
              IconData(
                aspect.iconCodePoint,
                fontFamily: aspect.iconFontFamily,
                fontPackage: aspect.iconFontPackage,
                matchTextDirection: aspect.iconDirection,
              ),
              color: Color(aspect.color),
            ),
            duration: task.duration,
            importance: goal.importance,
            type: 'Task'));
      }
    }

    //retrieve the aspect's habits
    for (var habit in aspect.habits.toList()) {
      /// the code is not going inside bc the habits are not being retieved!!!!!!
      itemList.add(Item(
        id: habit.id,
        description: habit.titel,
        completed: habit.completedForToday,
        icon: Icon(
          IconData(
            aspect.iconCodePoint,
            fontFamily: aspect.iconFontFamily,
            fontPackage: aspect.iconFontPackage,
            matchTextDirection: aspect.iconDirection,
          ),
          color: Color(aspect.color),
        ),
        duration: habit.durationInNumber,
        type: 'Habit',
      ));
    }
  }

  ///step 2: rank the list
  ///------------------------(add call to ranking code here, pass the item list as a parameter)----------------------------------------
  //reset check value each day
  if (TimeOfDay.now() == resetTime) {
    resetCheck(itemList);
  }

  ///Step3: visualize the list
  return Todo(id: 'todo-tag-1', description: 'مهام اليوم', items: itemList);
}

// empty todo
const emptyTasks = Todo(id: 'todo-tag-1', description: 'مهام اليوم', items: []);

//reset check value each day
void resetCheck(List<Item> itemList) {
  for (var item in itemList) {
    IsarService().reserCheck(item.id);
  }
}

////////////////////////////////////////Aspect Data\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

class WheelData with ChangeNotifier {
  List<Data> data = [
    //add friends and family aspect
    Data(name: 'Family and Friends', color: 4294938880, icon: Icons.person),
    //add Health and Wellbeing aspect
    Data(name: 'Health and Wellbeing', color: 4294956032, icon: Icons.spa),
    //add Personal Growth aspect
    Data(name: 'Personal Growth', color: 4281130443, icon: Icons.psychology),
    //add Physical Environment aspect
    Data(name: 'Physical Environment', color: 4288551408, icon: Icons.home),
    //add Significant Other aspect
    Data(name: 'Significant Other', color: 4294920521, icon: Icons.favorite),
    //add career aspect
    Data(name: 'career', color: 4278216099, icon: Icons.work),
    //add Fun and Recreation aspect
    Data(name: 'Fun and Recreation', color: 4278225631, icon: Icons.games),
    //add money and finances aspect
    Data(
        name: 'money and finances',
        color: 4283753312,
        icon: Icons.attach_money),
  ];
  List<Aspect> allAspects = [];
  List<Aspect> selected = [];
  List<String> selectedArabic = [];
   List<Goal> goalList =[];

  contains(String s) {
    for (var i = 0; i < data.length; i++) {
      if (data[i].name == s) {
        return true;
      } else {
        return false;
      }
    }
  }
}
