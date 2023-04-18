import 'package:flutter/material.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/local_task.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/models/todo_model.dart';
import 'package:motazen/pages/homepage/daily_tasks/ranking_algorithm.dart';
import 'package:motazen/pages/settings/tasklist_variables.dart';
import 'package:sorted/sorted.dart';

class ItemList {
//initialize attributes
  static List<Item> itemList = [];
  static List<Item> rankedList = [];
  static List<Item> dailyHabits = [];
  static List<Item> weeklyHabits = [];
  static List<Item> monthlyHabits = [];
  static List<Item> yearlyHabits = [];

//* adds the items to the items list, used when the item list is empty, and in the daily background process
  Future<void> createTaskTodoList(List<Aspect> aspectList) async {
    //initialize
    List<Item> taskItemList = [];

    if (itemList.isNotEmpty) {
      itemList.clear();
    }

    if (rankedList.isNotEmpty) {
      rankedList.clear();
    }

    //step1: add all tasks to a list
    for (var aspect in aspectList) {
      //retrieve the aspect's goals
      for (var goal in aspect.goals.toList()) {
        //retrive the goal's tasks
        for (var task in goal.task.toList()) {
          //skip completed tasks
          if (task.taskCompletionPercentage == 1) {
            continue;
          }
          //initialtize the importance to 0
          double importance = 0;

          //map the importance to the value used in the ranking equation
          switch (goal.importance) {
            case 1:
              importance = 0.25;
              break;
            case 2:
              importance = 0.5;
              break;
            case 3:
              importance = 0.75;
              break;
          }

          //create the dependancy graph
          Rank().createDepGraph(task);

          //ceate task items
          taskItemList.add(Item(
              description: task.name,
              completed: task.completedForToday,
              duration: task.duration,
              itemGoal: goal.id,
              id: task.id,
              icon: Icon(
                IconData(aspect.iconCodePoint,
                    fontFamily: aspect.iconFontFamily,
                    fontPackage: aspect.iconFontPackage,
                    matchTextDirection: aspect.iconDirection),
                color: Color(aspect.color),
              ),
              type: 'Task',
              daysCompletedTask: task.amountCompleted,
              dueDate: goal.endDate,
              importance: importance));
        }
      }
    }

    ///step 2: rank the list
    ///------------------------(add call to ranking code here, pass the item list as a parameter)----------------------------------------
    rankedList = Rank().calculateRank(taskItemList);

    //save the item's rank in local storage so that it's accessible after update the selection status
    for (var item in rankedList) {
      await IsarService().updateTaskRank(item.id, item.rank!);
    }

    ///Step3: visualize the list
    totalTaskNumbers = rankedList.length;
    itemList = rankedList.length < toShowTaskNumber
        ? rankedList
        : defaultTasklist
            ? rankedList
            : toShowTaskNumber == 0
                ? []
                : rankedList.sublist(0, toShowTaskNumber);
  } //end of create task list

//* updates the list when a task is checked
  Future<void> updateList() async {
    List<Item> temp = [];
    //calculate the rank
    for (var item in itemList) {
      //check items should be displayed at the bottom of the list
      if (item.completed) {
        item.rank = 0;
        continue;
      } else if (item.rank == 0) {
        LocalTask? task = await IsarService().findSepecificTaskByID(item.id);
        item.rank = task!.rank;
      }
    }
    temp = itemList.sorted(
        [SortedComparable<Item, double>((task) => task.rank!, invert: true)]);
    itemList.clear();
    itemList = temp;
  }

//* this method is used to update the list when a task has been deleted
  void removeTaskFromItemList(int id) {
    //remove the task from the item list
    itemList.removeWhere((element) => element.id == id);

    //remove the task from the ranked list
    rankedList.removeWhere((element) => element.id == id);
  }

//* this method initializes all the habits' lists
  void createHabitList(List<Aspect> aspectList) {
    List<Item> tempDailyHabits = [];
    List<Item> tempWeeklyHabits = [];
    List<Item> tempMonthlyHabits = [];
    List<Item> tempYearlyHabits = [];

    //step1: clear all habits's lists
    dailyHabits.clear();
    weeklyHabits.clear();
    monthlyHabits.clear();
    yearlyHabits.clear();

    //step2: add all habits to a list
    for (var aspect in aspectList) {
      //retrieve the aspect's habits
      for (var habit in aspect.habits.toList()) {
        //add to daily habit items
        if (habit.durationIndString == 0) {
          tempDailyHabits.add(Item(
            type: 'Habit',
            id: habit.id,
            description: habit.titel,
            completed: habit.completedForToday,
            icon: Icon(
              IconData(aspect.iconCodePoint,
                  fontFamily: aspect.iconFontFamily,
                  fontPackage: aspect.iconFontPackage,
                  matchTextDirection: aspect.iconDirection),
              color: Color(aspect.color),
            ),
            duration: habit.durationIndString,
            repetition: habit.durationInNumber,
          ));
        }
        //add to weekly habit list
        if (habit.durationIndString == 1) {
          tempWeeklyHabits.add(Item(
            type: 'Habit',
            id: habit.id,
            description: habit.titel,
            completed: habit.completedForToday,
            icon: Icon(
              IconData(aspect.iconCodePoint,
                  fontFamily: aspect.iconFontFamily,
                  fontPackage: aspect.iconFontPackage,
                  matchTextDirection: aspect.iconDirection),
              color: Color(aspect.color),
            ),
            duration: habit.durationIndString,
            repetition: habit.durationInNumber,
          ));
        }
        //add to monthly habit list
        if (habit.durationIndString == 2) {
          tempMonthlyHabits.add(Item(
            type: 'Habit',
            id: habit.id,
            description: habit.titel,
            completed: habit.completedForToday,
            icon: Icon(
              IconData(aspect.iconCodePoint,
                  fontFamily: aspect.iconFontFamily,
                  fontPackage: aspect.iconFontPackage,
                  matchTextDirection: aspect.iconDirection),
              color: Color(aspect.color),
            ),
            duration: habit.durationIndString,
            repetition: habit.durationInNumber,
          ));
        }

        //add to yearly habit list
        if (habit.durationIndString == 3) {
          tempYearlyHabits.add(Item(
            type: 'Habit',
            id: habit.id,
            description: habit.titel,
            completed: habit.completedForToday,
            icon: Icon(
              IconData(aspect.iconCodePoint,
                  fontFamily: aspect.iconFontFamily,
                  fontPackage: aspect.iconFontPackage,
                  matchTextDirection: aspect.iconDirection),
              color: Color(aspect.color),
            ),
            duration: habit.durationIndString,
            repetition: habit.durationInNumber,
          ));
        }
      }
    }

    ///step 3: order habits
    ///------------------------(add call to ranking code here, pass the item list as a parameter)----------------------------------------
    dailyHabits = Rank().orderHabits(tempDailyHabits);
    weeklyHabits = Rank().orderHabits(tempWeeklyHabits);
    monthlyHabits = Rank().orderHabits(tempMonthlyHabits);
    yearlyHabits = Rank().orderHabits(tempYearlyHabits);
  } //end of create list

  void clearList() {
    itemList.clear();
    rankedList.clear();
    dailyHabits.clear();
    weeklyHabits.clear();
    monthlyHabits.clear();
    yearlyHabits.clear();
  }

  //reset check value each day
  void resetCheck() {
    for (var item in itemList) {
      IsarService().reserCheck(item.id);
    }
  }
}
