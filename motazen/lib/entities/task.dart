// ignore_for_file: non_constant_identifier_names

class Task {
  //I am making it without id
  late List<String> TaskDependency;
  late String name;
  // List <Goal> goal = [];
  int amountCompleted = 0;
  double taskCompletionPercentage = 0;
  late int duration;
  late String durationDescribtion;
  Task({
    required this.TaskDependency,
    required this.amountCompleted,
    required this.duration,
    required this.durationDescribtion,
    // required this.goal,
    required this.name,
    required this.taskCompletionPercentage,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        // "goal": goal,
        "amountCompleted": amountCompleted,
        "taskCompletionPercentage": taskCompletionPercentage,
        "duration": duration,
        "durationDescribtion": durationDescribtion,
        "TaskDependency": TaskDependency,
        // "id": id,
      };
}
