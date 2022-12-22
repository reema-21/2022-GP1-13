// ignore_for_file: await_only_futures, camel_case_types

import 'package:flutter/material.dart';
import 'package:motazen/entities/LocalTask.dart';
import 'package:motazen/entities/goal.dart';
import '/entities/aspect.dart';
import 'models.dart';

///create the todo list
Todo createTodoList(List<Goal> goalList) {
  List<Item> itemList = [];
  List<LocalTask> taskList = [];
  for (var i = 0; i < goalList.length; i++) {
    taskList = goalList[i].task.toList();
    for (var item in taskList) {
      itemList.add(Item(
        itemGoal: goalList[i].id,
        id: item.id,
        description: item.name,
        //fix later
        icon: const Icon(
          Icons.person,
          color: Color(0xFFff9100),
        ),
      ));
    }
  }
  return Todo(id: 'todo-tag-1', description: 'مهام اليوم', items: itemList);
}

// empty todo
const emptyTasks = Todo(id: 'todo-tag-1', description: 'مهام اليوم', items: []);

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
