import 'package:motazen/entities/local_task.dart';

import 'package:motazen/entities/goal.dart';
import '../../entities/aspect.dart';
import '../../isar_service.dart';
import '../select_aspectPage/handle_aspect_data.dart';

class CalculateProgress {
  Future<void> updateAmountCompleted(
      int taskId, int? goalId, String operation, String type) async {
    String methodToBeUsed = '$operation $type';

    switch (methodToBeUsed) {
      case 'Increment Task':
        await IsarService().completeForTodayTask(taskId);
        await calculateTaskPercentage(taskId, goalId!);
        break;
      case 'Decrement Task':
        await IsarService().undoCompleteForTodayTask(taskId);
        await calculateTaskPercentage(taskId, goalId!);
        break;
      case 'Increment Habit':
        await IsarService().completeForTodayHabit(taskId);
        break;
      case 'Decrement Habit':
        await IsarService().undoCompleteForTodayHabit(taskId);
        break;
      default:
        return; // Exit function if methodToBeUsed is invalid
    }
  }

  Future<void> calculateTaskPercentage(int taskId, int goalId) async {
    LocalTask? completedTask =
        await IsarService().findSepecificTaskByID(taskId);
    Goal? goal = await IsarService().getSepecificGoall(goalId);

    double completionPercentage =
        completedTask!.amountCompleted / completedTask.duration;
    if (completionPercentage < 1 || completionPercentage == 1) {
      await IsarService().updateTaskPercentage(taskId, completionPercentage);
      await calculateGoalPercentage(goal, goal!.goalProgressPercentage);
    }
  }

  Future<void> calculateGoalPercentage(
      Goal? goal, double previousProgress) async {
    double totalDaysCompleted = 0;
    int totalGoalDuration = 0;
    double totalGoalProgress = 0;

    //save the previous goal progress
    List<LocalTask> allTasks = goal!.task.toList();
    for (var element in allTasks) {
      totalDaysCompleted += element.amountCompleted;
      totalGoalDuration += element.duration;
    }
    totalGoalProgress = totalDaysCompleted / totalGoalDuration;

    if (totalGoalProgress < 1 || totalGoalProgress == 1) {
      await IsarService().updateGoalPercentage(goal.id, totalGoalProgress);
      Aspect? aspect = await IsarService().getAspectByGoal(goal.id);
      HandleAspect()
          .updateAspects(aspect!, goal, previousProgress, totalGoalProgress);
    }
  }
}
