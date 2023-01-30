import 'package:directed_graph/directed_graph.dart';
import 'package:motazen/data/models.dart';
import 'package:motazen/entities/LocalTask.dart';
import 'package:sorted/sorted.dart';

class Rank {
  static DirectedGraph<String> graph = DirectedGraph({});
  void createDepGraph(LocalTask task) {
    ///Note: check dep
    ///check if the graph contains the task, if not
    ///add the task to the graph
    if (!graph.contains('${task.id}')) {
      graph.addEdges('${task.id}', {});
    }

    //add the dependencies of the task
    for (var element in task.TaskDependency.toList()) {
      graph.edgeExists('${task.id}', '${element.id}');
    }

    ///Note: there should probably be a remove case for both dependancies
    ///and tasks
  }

//Calculate NT(the normalized time criteria value) for each task
  void calculateNT(List<Item> tasks) {
    double timeLeft;
    double maxTime;
    for (var task in tasks) {
      //first we need to calculate the time left for each task
      timeLeft = task.duration! -
          task.daysCompletedTask! /
              task.dueDate!.difference(DateTime.now()).inDays.toDouble();
      //save the time left (in the actual code we probably need to save thid data in isar
      task.timeLeft = timeLeft;
    }

    //Find the task with the most time left
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
      double dependency = graph.inDegree("${task.id}")! / tasks.length;
      task.depandancies = dependency;
    }
  }

  List<Item> calculateRank(List<Item> tasks) {
    const double weight = 0.33;
    //we need to calculate the NT first
    calculateNT(tasks);

    //calculate dependancy
    calculateDependancy(tasks);

    //calculate the rank
    for (var task in tasks) {
      ///there is an issue with importance (check)
      task.rank = weight * task.importance! +
          -weight * task.NT +
          weight * task.depandancies;
    }
    //sort list
    return tasks.sorted(
        [SortedComparable<Item, double>((task) => task.rank!, invert: true)]);
  }
}
///Currents issues with the algorithm:
///Note: when all other variables are equal, but the daycompleted are different
///more priority is given to the task with MORE days completed, is this correct
