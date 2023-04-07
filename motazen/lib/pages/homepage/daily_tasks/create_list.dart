import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/models/todo_model.dart';
import 'package:motazen/pages/homepage/daily_tasks/ranking_algorithm.dart';
import 'package:motazen/pages/settings/tasklist_variables.dart';

var cron = Cron();
//*create the todo list
Todo createTaskTodoList(List<Aspect> aspectList) {
  //initialize
  List<Item> taskItemList = [];
  cron.schedule(Schedule.parse('0 0 * * *'), () async {
    //Clear the selected values
    for (var item in taskItemList) {
      IsarService().reserCheck(item.id);
    } //update the list
    createTaskTodoList(aspectList);
  });

  //step1: add all tasks to a list
  for (var aspect in aspectList) {
    //retrieve the aspect's goals
    for (var goal in aspect.goals.toList()) {
      //retrive the goal's tasks
      for (var task in goal.task.toList()) {
        //! this should be done after the new day reset
        // //skip completed tasks
        // if (task.taskCompletionPercentage == 1) {
        //   continue;
        // }
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
  List<Item> rankedList = Rank().calculateRank(taskItemList);

  ///Step3: visualize the list
  totalTaskNumbers = rankedList.length;
  return Todo(
      //هنا تغيير عددهم
      id: 'todo-tag-1',
      items: rankedList.length < toShowTaskNumber
          ? rankedList
          : defaultTasklist
              ? rankedList
              : toShowTaskNumber == 0
                  ? []
                  : rankedList.sublist(0, toShowTaskNumber));
} //end of create task list

Todo? createHabitDailyTodoList(List<Aspect> aspectList) {
  //initialize
  List<Item> habitItemList = [];

  //step1: add all habits to a list
  for (var aspect in aspectList) {
    //retrieve the aspect's habits
    for (var habit in aspect.habits.toList()) {
      //create habit items
      if (habit.durationIndString == 0) {
        habitItemList.add(Item(
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

  ///step 2: order habits
  ///------------------------(add call to ranking code here, pass the item list as a parameter)----------------------------------------
  List<Item> orderedList = Rank().orderHabits(habitItemList);

  ///Step3: visualize the list
  if (orderedList.isNotEmpty) {
    return Todo(id: 'todo-tag-1', items: orderedList);
  } else {
    return null;
  }
} //end of create list

Todo? createHabitWeeklyTodoList(List<Aspect> aspectList) {
  //initialize
  List<Item> habitItemList = [];

  //step1: add all habits to a list
  for (var aspect in aspectList) {
    //retrieve the aspect's habits
    for (var habit in aspect.habits.toList()) {
      //create habit items
      if (habit.durationIndString == 1) {
        habitItemList.add(Item(
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

  ///step 2: order habits
  ///------------------------(add call to ranking code here, pass the item list as a parameter)----------------------------------------
  List<Item> orderedList = Rank().orderHabits(habitItemList);

  ///Step3: visualize the list
  if (orderedList.isNotEmpty) {
    return Todo(id: 'todo-tag-1', items: orderedList);
  } else {
    return null;
  }
} //end of create list

Todo? createHabitMonthlyTodoList(List<Aspect> aspectList) {
  //initialize
  List<Item> habitItemList = [];

  //step1: add all habits to a list
  for (var aspect in aspectList) {
    //retrieve the aspect's habits
    for (var habit in aspect.habits.toList()) {
      //create habit items
      if (habit.durationIndString == 2) {
        habitItemList.add(Item(
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

  ///step 2: order habits
  ///------------------------(add call to ranking code here, pass the item list as a parameter)----------------------------------------
  List<Item> orderedList = Rank().orderHabits(habitItemList);

  ///Step3: visualize the list
  if (orderedList.isNotEmpty) {
    return Todo(id: 'todo-tag-1', items: orderedList);
  } else {
    return null;
  }
} //end of create list

Todo? createHabitYearlyTodoList(List<Aspect> aspectList) {
  //initialize
  List<Item> habitItemList = [];

  //step1: add all habits to a list
  for (var aspect in aspectList) {
    //retrieve the aspect's habits
    for (var habit in aspect.habits.toList()) {
      //create habit items
      if (habit.durationIndString == 3) {
        habitItemList.add(Item(
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

  ///step 2: order habits
  ///------------------------(add call to ranking code here, pass the item list as a parameter)----------------------------------------
  List<Item> orderedList = Rank().orderHabits(habitItemList);

  ///Step3: visualize the list
  if (orderedList.isNotEmpty) {
    return Todo(id: 'todo-tag-1', items: orderedList);
  } else {
    return null;
  }
} //end of create list

// empty todo
const emptyTasks = Todo(id: 'todo-tag-1', items: []);

//reset check value each day
void resetCheck(List<Item> itemList) {
  for (var item in itemList) {
    IsarService().reserCheck(item.id);
  }
}
