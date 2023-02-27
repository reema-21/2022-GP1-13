import 'package:directed_graph/directed_graph.dart';
import 'package:motazen/entities/LocalTask.dart';
import 'package:motazen/models/todo_model.dart';
import 'package:sorted/sorted.dart';

class Rank {
  ////////////////////Ranking tasks/////////////
  static DirectedGraph<String> graph = DirectedGraph({});
  void createDepGraph(LocalTask task) {
    ///check if the graph contains the task, if not
    ///add the task to the graph
    if (!graph.contains('${task.id}')) {
      graph.addEdges('${task.id}', {});
    }

    ///if the task was deleted
    ///remove the task from the graph using an else statement here
    ///this is the optimal way

    //add the dependencies of the task
    for (var element in task.TaskDependency.toList()) {
      if (!graph.edgeExists('${task.id}', '${element.id}')) {
        graph.addEdges('${task.id}', {'${element.id}'});
      }
    }

    ///Note: there should probably be a remove case for both dependancies
    ///and tasks
  }

//Calculate NT(the normalized time criteria value) for each task
  void calculateNT(List<Item> tasks) {
    double timeLeft;
    double maxTime;
    double diff;
    if (tasks.isEmpty) {
      return;
    }
    for (var task in tasks) {
      //find how many days are left till the due date
      if (task.dueDate!.difference(DateTime.now()).inDays.toDouble() == 0) {
        diff = task.dueDate!.difference(DateTime.now()).inMinutes.toDouble() /
            24 /
            60;
      } else {
        diff = task.dueDate!.difference(DateTime.now()).inDays.toDouble();
      }

      //Calculate the time left for each task
      timeLeft = (task.duration! - task.daysCompletedTask!) / diff;
      //save the time left (in the actual code we probably need to save thid data in isar
      task.timeLeft = timeLeft;
    }

    ///Find the task with the most time left
    Item taskWithMaxT = tasks.reduce(
        (item1, item2) => item1.timeLeft > item2.timeLeft ? item1 : item2);
    //save the maximum time left
    maxTime = taskWithMaxT.timeLeft;
    //Next we need to normalize the data
    for (var task in tasks) {
      task.NT = task.timeLeft / maxTime;
    }
  }

  void calculateDependancy(List<Item> tasks) {
    for (var task in tasks) {
      double dependency =
          graph.inDegree('${task.id}')!.toDouble() / tasks.length;
      task.depandancies = dependency;
    }
  }

  List<Item> calculateRank(List<Item> tasks) {
    const double weight = 0.33;
    final now = DateTime.now();
    //we need to calculate the NT first
    calculateNT(tasks);

    //calculate dependancy
    calculateDependancy(tasks);

    //calculate the rank
    for (var task in tasks) {
      //check items should be displayed at the bottom of the list
      if (task.completed) {
        task.rank = 0;
        continue;
      }
      //items past due should be displayed at the top of the list
      if (task.dueDate!.isBefore(now)) {
        task.rank = 1;
      } else {
        task.rank = (weight * task.importance!) +
            (weight * task.NT) +
            (weight * task.depandancies);
      }
    }

    ///Note: this is a temporary solution, ideally
    ///I would only delete the removed item only
    graph.clear();
    //sort list
    return tasks.sorted(
        [SortedComparable<Item, double>((task) => task.rank!, invert: true)]);
  }

/////////////////////ordering habits by frequency//////////////
  List<Item> orderHabits(List<Item> habits) {
    double duration = 0;

    for (var habit in habits) {
      switch (habit.duration) {
        case 0:
          //repeated during a day
          duration = 365;
          break;
        case 1:
          //repeated during a week
          duration = 54; //!approxiamet value, revise later
          break;
        case 2:
          //repeated during a month
          duration = 12;
          break;
        case 3:
          //repeated during a year
          duration = 1;
          break;
      }
      //check items should be displayed at the bottom of the list
      if (habit.completed) {
        habit.rank = 0;
      } else {
        //find the total repution
        habit.rank = (habit.repetition! * duration);
      }
    }

    return habits.sorted(
        [SortedComparable<Item, double>((habit) => habit.rank!, invert: true)]);
  }
}
