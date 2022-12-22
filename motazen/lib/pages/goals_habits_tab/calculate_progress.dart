import 'package:motazen/entities/LocalTask.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/isarService.dart';

import '../../entities/aspect.dart';
import '../select_aspectPage/handle_aspect_data.dart';

class CalculateProgress {
  void updateAmountCompleted(int taskId, int goalId) {
    IsarService().incrementAmountCompleted(taskId);
    calculateTaskPercentage(taskId, goalId);
  }

  Future<void> calculateTaskPercentage(int taskId, int goalId) async {
    //later make sure that if the percentage is 1 then the task is complete
    LocalTask? completedTask = await IsarService().getSepecificTask(taskId);
    Goal? goal = await IsarService().getSepecificGoall(goalId);
    double completionPercentage =
        completedTask!.amountCompleted / completedTask.duration;
    //check if the task has been completed
    if (completionPercentage <= 1) {
      print('less than 1');
      IsarService().updateTaskPercentage(taskId, completionPercentage);
      calculateGoalPercentage(goal);
    } else {
      print('1 or more');
      IsarService().decrementAmountCompleted(taskId);
    }
  }

  Future<void> calculateGoalPercentage(Goal? goal) async {
    double totalDaysCompleted = 0;
    double totalGoalProgress = 0;
    List<LocalTask> allTasks = goal!.task.toList(); //the issue is probably here
    for (var element in allTasks) {
      totalDaysCompleted = totalDaysCompleted + element.amountCompleted;
    }
    totalGoalProgress = totalDaysCompleted / goal.goalDuration;
    IsarService().updateGoalPercentage(goal.id, totalGoalProgress);
    Aspect? aspect = await IsarService().getAspectByGoal(goal.id);
    handle_aspect().updateAspects(aspect!);
  }
}
