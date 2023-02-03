import 'package:motazen/entities/LocalTask.dart';
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
        calculateTaskPercentage(taskId, goalId!);
        break;
      case 'Decrement Task':
        await IsarService().undoCompleteForTodayTask(taskId);
        calculateTaskPercentage(taskId, goalId!);
        break;
      case 'Increment Habit':
        await IsarService().completeForTodayHabit(taskId);
        break;
      case 'Decrement Habit':
        await IsarService().undoCompleteForTodayHabit(taskId);
        break;
      default:
    }
  }

  Future<void> calculateTaskPercentage(int taskId, int goalId) async {
    LocalTask? completedTask = await IsarService().getSepecificTask(taskId);
    Goal? goal = await IsarService().getSepecificGoall(goalId);
    double completionPercentage =
        completedTask!.amountCompleted / completedTask.duration;
    //check if the value is within range
    if (completionPercentage < 1 || completionPercentage == 1) {
      IsarService().updateTaskPercentage(taskId, completionPercentage);
      calculateGoalPercentage(goal, goal!.goalProgressPercentage);
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
      totalDaysCompleted = totalDaysCompleted + element.amountCompleted;
      totalGoalDuration = totalGoalDuration + element.duration;
    }
    totalGoalProgress = totalDaysCompleted / totalGoalDuration;

    //check if the progress is within range
    if (totalGoalProgress < 1 || totalGoalProgress == 1) {
      IsarService().updateGoalPercentage(goal.id, totalGoalProgress);
      Aspect? aspect = await IsarService().getAspectByGoal(goal.id);
      handle_aspect()
          .updateAspects(aspect!, goal, previousProgress, totalGoalProgress);
    }
  }
}
