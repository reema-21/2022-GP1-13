import 'package:motazen/entities/LocalTask.dart';
import 'package:motazen/entities/goal.dart';

import '../../entities/aspect.dart';
import '../../isar_service.dart';
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
      IsarService().updateTaskPercentage(taskId, completionPercentage);
      calculateGoalPercentage(goal);
    } else {
      IsarService().decrementAmountCompleted(taskId);
    }
  }

  Future<void> calculateGoalPercentage(Goal? goal) async {
    double totalDaysCompleted = 0;
    int totalGoalDuration = 0;
    double totalGoalProgress = 0;
    List<LocalTask> allTasks = goal!.task.toList(); //the issue is probably here
    for (var element in allTasks) {
      totalDaysCompleted = totalDaysCompleted + element.amountCompleted;
      totalGoalDuration = totalGoalDuration + element.duration;
    }
    totalGoalProgress = totalDaysCompleted / totalGoalDuration;
    //it still passes when it's grater than 1 (bug)
    if (totalGoalProgress < 1.00) {
      IsarService().updateGoalPercentage(goal.id, totalGoalProgress);
      Aspect? aspect = await IsarService().getAspectByGoal(goal.id);
      handle_aspect().updateAspects(aspect!);
    }
  }
}
