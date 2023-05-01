import 'package:flutter/material.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/local_task.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/models/todo_model.dart';
import 'package:motazen/pages/homepage/daily_tasks/ranking_algorithm.dart';
import 'package:motazen/pages/settings/tasklist_variables.dart';

class ItemList {
//initialize attributes
  static List<Item> itemList = [];
  static List<Item> rankedList = [];
  static List<Item> dailyHabits = [];
  static List<Item> weeklyHabits = [];
  static List<Item> monthlyHabits = [];
  static List<Item> yearlyHabits = [];
  static DateTime? lastResetDate;

//* adds the items to the items list, used when the item list is empty, and in the daily background process
  Future<void> createTaskTodoList(List<Aspect> aspectList) async {
    // check if a new day has started
    if (lastResetDate == null || lastResetDate!.day != DateTime.now().day) {
      await resetCheck(aspectList);
      lastResetDate = DateTime.now();
    }

    //step1: add all tasks to a list
    itemList.clear();
    for (var aspect in aspectList) {
      //retrieve the aspect's goals
      for (var goal in aspect.goals) {
        //retrive the goal's tasks
        for (var task in goal.task) {
          //skip completed tasks if the last completion date is before today
          if (task.lastCompletionDate != null &&
              task.lastCompletionDate!.year == DateTime.now().year &&
              task.lastCompletionDate!.month == DateTime.now().month &&
              task.lastCompletionDate!.day < DateTime.now().day) {
            continue;
          }
          print('task: ${task.name}');
          //initialize the importance to 0
          double importance = goal.importance / 4;

          //create the dependency graph
          Rank().createDepGraph(task);

          //create task items
          itemList.add(Item(
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
            importance: importance,
          ));
        }
      }
    }

    //step 2: rank the list
    Rank().calculateRank(itemList);
    rankedList = itemList;

    //save the item's rank in local storage so that it's accessible after updating the selection status
    for (var item in rankedList) {
      await IsarService().updateTaskRank(item.id, item.rank!);
    }

    //step 3: visualize the list
    totalTaskNumbers = rankedList.length;
    if (rankedList.length < toShowTaskNumber) {
      itemList = rankedList;
    } else if (defaultTasklist) {
      itemList = rankedList;
    } else if (toShowTaskNumber == 0) {
      itemList.clear();
    } else {
      itemList = rankedList.sublist(0, toShowTaskNumber);
    }
  }

//* updates the list when a task is checked
  Future<void> updateList(List<Aspect> aspectList) async {
    // check if a new day has started
    if (lastResetDate == null || lastResetDate!.day != DateTime.now().day) {
      await resetCheck(aspectList);
      lastResetDate = DateTime.now();
    }

    //calculate the rank
    for (var item in itemList) {
      //check items should be displayed at the bottom of the list
      if (item.completed &&
          item.lastCompletionDate != null &&
          item.lastCompletionDate!.year == DateTime.now().year &&
          item.lastCompletionDate!.month == DateTime.now().month &&
          item.lastCompletionDate!.day < DateTime.now().day) {
        item.rank = 0;
        lastResetDate =
            DateTime.now(); // update lastResetDate when an item is checked
      } else if (item.rank == 0) {
        LocalTask? task = await IsarService().findSepecificTaskByID(item.id);
        item.rank = task!.rank;
      }
    }
    itemList = bucketSort(itemList);
  }

  List<Item> bucketSort(List<Item> items) {
    // Create an array of empty buckets
    final List<List<Item>> buckets = List.generate(items.length + 1, (_) => []);

    // Add each item to the appropriate bucket based on its rank
    for (var item in items) {
      int index = (item.rank! * items.length).floor();
      buckets[index].add(item);
    }

    // Concatenate the buckets into a single list
    List<Item> result = [];
    for (var bucket in buckets.reversed) {
      result.addAll(bucket);
    }

    return result;
  }

//* reset the check status of all tasks in the database
  Future<void> resetCheck(List<Aspect> aspectList) async {
    for (var aspect in aspectList) {
      for (var goal in aspect.goals) {
        for (var task in goal.task) {
          if (task.lastCompletionDate != null &&
              task.lastCompletionDate!.year == DateTime.now().year &&
              task.lastCompletionDate!.month == DateTime.now().month &&
              task.lastCompletionDate!.day < DateTime.now().day) {
            IsarService().reserCheck(task.id);
          }
        }
      }
    }
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
}
