import 'package:directed_graph/directed_graph.dart';
import 'package:motazen/data/models.dart';
import 'package:motazen/entities/LocalTask.dart';
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
    if (tasks.isEmpty) {
      return;
    }
    for (var task in tasks) {
      //first we need to calculate the time left for each task
      timeLeft = (task.duration! - task.daysCompletedTask!) /
          task.dueDate!.difference(DateTime.now()).inDays.toDouble();
      //save the time left (in the actual code we probably need to save thid data in isar
      task.timeLeft = timeLeft;
    }

    ///Find the task with the most time left
    ///(Note: there are case where timeLeft = infinity)
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
      if (task.dueDate!.isBefore(now)) {
        task.rank = 1;
      } else {
        task.rank = weight * task.importance! +
            -weight * task.NT +
            weight * task.depandancies;
      }
    }

    ///Note: this is a temporary solution, ideally
    ///I would only delete the removed item
    graph.clear();
    //sort list
    return tasks.sorted(
        [SortedComparable<Item, double>((task) => task.rank!, invert: true)]);
  }

/////////////////////ordering habits by frequency//////////////
  // List<Item> orderHabits() {

  // }
}