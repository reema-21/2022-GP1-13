import 'package:flutter/cupertino.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/entities/local_task.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/models/todo_model.dart';
import 'package:motazen/pages/goals_habits_tab/calculate_progress.dart';
import 'package:motazen/pages/homepage/daily_tasks/ranking_algorithm.dart';
import 'package:motazen/pages/settings/tasklist_variables.dart';
import 'package:motazen/widget/list_popups.dart';
import 'package:sorted/sorted.dart';

class ItemListProvider with ChangeNotifier {
  final _isar = IsarService();
  final List<Item> _itemList = [];
  List<Item> _rankedList = [];
  List<Item> sublist = [];
  static DateTime? lastResetDate;
//* adds the items to the items list, used when the item list is empty, and in the daily background process
  Future<void> createTaskTodoList() async {
    // check if a new day has started
    if (lastResetDate == null || lastResetDate!.day != DateTime.now().day) {
      await resetCheck();
      lastResetDate = DateTime.now();
    }

    final tasks = await _isar.getAllTasks();

    //step1: add all tasks to a list
    _itemList.clear();
    for (var task in tasks) {
      Goal? goal = task.goal.value;
      Aspect? aspect = goal!.aspect.value;
      if (goal.endDate.isBefore(DateTime.now())) {
        // Set rank to 1 for past due tasks
        task.rank = 1;
        continue;
      }
      //initialize the importance to 0
      double importance = goal.importance / 4;

      //create the dependency graph
      Rank().createDepGraph(task);

      // set the rank to 0 if the task is completed
      double? rank = task.completedForToday ? 0 : null;
      //create task items
      _itemList.add(Item(
        description: task.name,
        completed: task.completedForToday,
        duration: task.duration,
        itemGoal: goal.id,
        id: task.id,
        icon: Icon(
          IconData(aspect!.iconCodePoint,
              fontFamily: aspect.iconFontFamily,
              fontPackage: aspect.iconFontPackage,
              matchTextDirection: aspect.iconDirection),
          color: Color(aspect.color),
        ),
        type: 'Task',
        daysCompletedTask: task.amountCompleted,
        dueDate: goal.endDate,
        importance: importance,
        rank: rank,
      ));
    }

    //step 2: rank the list
    _rankedList = Rank().calculateRank(_itemList);

    //save the item's rank in local storage so that it's accessible after updating the selection status
    for (var item in _rankedList) {
      await IsarService().updateTaskRank(item.id, item.rank ?? 0);
    }

    //step 3: take the sublist
    totalTaskNumbers = _rankedList.length;
    if (_rankedList.length < toShowTaskNumber) {
      sublist = _rankedList;
    } else {
      sublist = _rankedList.sublist(0, toShowTaskNumber);
    }

    sublist = sublist.sorted(
        [SortedComparable<Item, double>((task) => task.rank!, invert: true)]);
    // notifyListeners(); //this might be the problem
  }

//* updates the list when a task is checked
  Future<void> updateList() async {
    // check if a new day has started
    if (lastResetDate == null || lastResetDate!.day != DateTime.now().day) {
      await resetCheck();
      lastResetDate = DateTime.now();
    }

    //calculate the rank
    for (var item in sublist) {
      //set rank to 0 for checked tasks
      if (item.completed) {
        item.rank = 0;
      }
      if (item.lastCompletionDate != null &&
          item.lastCompletionDate!.year == DateTime.now().year &&
          item.lastCompletionDate!.month == DateTime.now().month &&
          item.lastCompletionDate!.day < DateTime.now().day) {
        lastResetDate =
            DateTime.now(); // update lastResetDate when an item is checked
      } else if (item.rank == 0 && !(item.completed)) {
        //retrieve the task's rank from local storage
        LocalTask? task = await IsarService().findSepecificTaskByID(item.id);
        item.rank = task!.rank;
      }
    }
    sublist = sublist.sorted(
        [SortedComparable<Item, double>((task) => task.rank!, invert: true)]);
    notifyListeners();
  }

//* reset the check status of all tasks in the database
  Future<void> resetCheck() async {
    final tasks = await _isar.getAllTasks();
    for (var task in tasks) {
      IsarService().reserCheck(task.id);
    }
  }

  Future<void> toggle(int index, BuildContext context) async {
    if (sublist[index].completed) {
      //completed = true, then we need to decrement
      sublist[index].completed = false;
      if (sublist[index].daysCompletedTask != null) {
        sublist[index].daysCompletedTask =
            sublist[index].daysCompletedTask! - 1;
      }
      await CalculateProgress().updateAmountCompleted(sublist[index].id,
          sublist[index].itemGoal, 'Decrement', sublist[index].type);
      await updateList();
    } else {
      //completed = false, then we need to increment
      sublist[index].completed = true;
      if (sublist[index].daysCompletedTask != null) {
        sublist[index].daysCompletedTask =
            sublist[index].daysCompletedTask! + 1;
      }
      await CalculateProgress().updateAmountCompleted(sublist[index].id,
          sublist[index].itemGoal, 'Increment', sublist[index].type);
      await updateList();
      bool isTaskCompleted =
          (sublist[index].duration - sublist[index].daysCompletedTask) == 0;
      if (context.mounted && isTaskCompleted) {
        //a user has finished a task
        showCupertinoDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return const ListDialog(
                title: 'اكتملت المهمة!',
                description: 'احسنت، لقد انتهيت من هذه المهمة',
                imagePath: 'assets/animations/Complete_task.json',
              );
            });
      }
    }
    notifyListeners();
  }
}
