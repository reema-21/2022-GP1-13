import 'package:flutter/material.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/models/todo_model.dart';
import 'package:motazen/pages/homepage/daily_tasks/ranking_algorithm.dart';

class ItemList {
//initialize attributes
  static List<Item> dailyHabits = [];
  static List<Item> weeklyHabits = [];
  static List<Item> monthlyHabits = [];
  static List<Item> yearlyHabits = [];

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
    dailyHabits.clear();
    weeklyHabits.clear();
    monthlyHabits.clear();
    yearlyHabits.clear();
  }
}
