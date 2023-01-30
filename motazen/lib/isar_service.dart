// ignore_for_file: file_names, non_constant_identifier_names, await_only_futures
//here is manaras
import 'package:firebase_auth/firebase_auth.dart';
import 'package:motazen/entities/CommunityID.dart';
import 'package:motazen/entities/LocalTask.dart';
import 'package:motazen/entities/imporvment.dart';
import '/entities/aspect.dart';
import '/entities/goal.dart';
import '/entities/habit.dart';
import 'package:isar/isar.dart';

class IsarService {
  late Future<Isar> db;
  IsarService() {
    db = openIsar();
  }
  static String get getUserID => FirebaseAuth.instance.currentUser?.email ?? "";

  Future<Isar> openIsar() async {
    if (Isar.instanceNames.isEmpty) {
      //if didn't opend before open one if iopen used an exsit one
      return await Isar.open(
          [
            AspectSchema,
            GoalSchema,
            LocalTaskSchema,
            HabitSchema,
            ImporvmentSchema,
            CommunityIDSchema
          ] //still the habit schema
          ,
          inspector: true);
    }
    return Future.value(Isar.getInstance());
  }

  /// ADD GOALS , ADD TASKS , ADD ASPECT  */
  Future<bool> createGoal(Goal newgoal) async {
    //Add goals
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.goals.putSync(newgoal));
    return true;
  } //<int> because we want to get the id of the  ceated thing

  void UpdateTask(LocalTask tem) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.localTasks.put(tem);
    });
  }

  Future<LocalTask?> getSepecificTask(int id) async {
    final isar = await db;
    return await isar.localTasks
        .where()
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .idEqualTo(id)
        .findFirst();
  }

  Future<LocalTask?> findSepecificTask2(String name) async {
    final isar = await db;
    return await isar.localTasks
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .nameContains(name)
        .goalIsNull()
        .findFirst();
  }

  void deleteTask3(LocalTask task) async {
    final isar = await db;

    await isar.writeTxn(() async {
      LocalTask? ttask = await isar.localTasks
          .filter()
          .nameContains(task.name)
          .goalIsNull()
          .findFirst();

      await isar.localTasks.delete(ttask!.id);
    });
  }

  void deleteCommunity(String id) async {
    final isar = await db;

    await isar.writeTxn(() async {
      CommunityID? ttask = await isar.communityIDs
          .filter()
          .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
          .communityIdEqualTo(id)
          .findFirst();

      await isar.communityIDs.delete(ttask!.id);
    });
  }

  Future<void> createHabit(Habit newHabit) async {
    //Add habits
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.habits.putSync(newHabit));
  }

  Future<void> CreateCommunity(CommunityID newCommunity) async {
    //Add habits
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.communityIDs.putSync(newCommunity));
  }

  Future<void> createAspect(Aspect newAspect) async {
    //Add aspect
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.aspects.putSync(newAspect));
  }

  /// ******************** */
  //we are listiening for data not just getting //
  Stream<List<Goal>> getAllGoals() async* {
    //Streams so that it is reflected when add immedeitly .
    final isar = await db;
    yield* isar.goals
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .watch(fireImmediately: true);
  }

  ///return a list of all goals
  Future<List<Goal>> getGoals() async {
    final isar = await db;
    return isar.goals
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .findAll();
  }

  Stream<List<Aspect>> getAllAspects() async* {
    final isar = await db;
    yield* isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .watch(fireImmediately: true);
  }

  Stream<List<Habit>> getAllHabits() async* {
    final isar = await db;
    yield* isar.habits
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .watch(fireImmediately: true);
  }

  Stream<List<Aspect>> getSelectedAspectsStream() async* {
    final isar = await db;
    yield* isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .isSelectedEqualTo(true)
        .watch(fireImmediately: true);
  }

  Future<LocalTask?> findSepecificTask(String name) async {
    final isar = await db;
    return await isar.localTasks
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .nameEqualTo(name)
        .findFirst();
  }

  Future<CommunityID?> findCommunity(String id) async {
    final isar = await db;
    return await isar.communityIDs
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .communityIdEqualTo(id)
        .findFirst();
  }

  // THER IS ANOTHE WAY IF YOU DON'T NEED IT AS STREAM .
  //just get the apsect --> i will use get because it is not sth that is changed or add frequenctly .

  Future<List<Aspect>> getAspectFirstTime() async {
    final isar = await db;
    return isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .findAll();
  }

  Future<Map<String, double>> getpointsAspects(List<Aspect> aspects) async {
    //get a list of aspect/points
    final isar = await db;
    Map<String, double> pointsList = {};
    for (int i = 0; i < aspects.length; i++) {
      String tempAspect = aspects[i].name;
      Aspect? tempPoints = await isar.aspects
          .filter()
          .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
          .idEqualTo(aspects[i].id)
          .findFirst();
      pointsList[tempAspect] = tempPoints!.percentagePoints;
    }

    return pointsList;
  }

  Future<void> assignPointAspect(String aspectName, double points) async {
    final isar = await db;
    Aspect? tempAspect = await isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .nameEqualTo(aspectName)
        .findFirst();
    tempAspect?.percentagePoints = points;
    tempAspect!.percentagePoints = points;
    Imporvment newImprove = Imporvment(userID: IsarService.getUserID);
    newImprove.date = DateTime.utc(2023, 1, 1); //!Should be DateTime.now();
    newImprove.sum = points;
    tempAspect.imporvmentd.add(newImprove);
    isar.writeTxnSync<int>(() => isar.aspects.putSync(tempAspect));

    // final isar = await db;
    // Aspect newAspect = Aspect(userID: IsarService.getUserID);
    // newAspect.name = aspectName;
    // newAspect.percentagePoints = points;
    // await isar.writeTxnSync<int>(() => isar.aspects.putSync(newAspect)); // update that object
  }

  // to get all other collection records based on a specific Aspect
  // get points for a specfic aspect
  //get goals for a specfic aspect
  //get habits for a specific aspect

//NOTE!!!!!!! I am taking based on the name not the id !!!!!!!!!!!!!!!!/

  Future<List<Goal>> getAspectGoals(Aspect aspect) async {
    final isar = await db;
    return await isar.goals
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .aspect((q) => q.nameContains(aspect.name))
        .findAll();
  }

  Future<List<Habit>> getAspectHabits(Aspect aspect) async {
    final isar = await db;
    return await isar.habits
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .aspect((q) => q.nameContains(aspect.name))
        .findAll();
  }

  Future<List<Aspect>> getchoseAspect() async {
    ///remove if my implementation works
    final isar = await db;
    return await isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .percentagePointsGreaterThan(0)
        .findAll();
  }

  Future<Aspect?> findSepecificAspect(String name) async {
    final isar = await db;
    return await isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .nameEqualTo(name)
        .findFirst();
  }

// changes
  Future<void> saveTask(LocalTask task) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.localTasks.putSync(task));
  }

  Future<void> updateTask(LocalTask task) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.localTasks.putSync(task));
  }

  Future<void> deleteTask(int id) async {
    final isar = await db;
    isar.writeTxnSync<bool>(() => isar.localTasks.deleteSync(id));
  }

  Stream<List<LocalTask>> listenTasks() async* {
    final isar = await db;
    yield* isar.localTasks
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .watch(fireImmediately: true);
  }

  Future<Goal?> getSepecificGoal(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      return await isar.goals
          .filter()
          .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
          .idEqualTo(id);
    });
    return null;
  }

  Future<Aspect?> getAspectByGoal(int goalId) async {
    final isar = await db;
    return await isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .goals((q) => q.idEqualTo(goalId))
        .findFirstSync();
  }

  Future<Goal?> getSepecificGoall(int id) async {
    final isar = await db;

    return await isar.goals
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .idEqualTo(id)
        .findFirstSync();
  }

  Future<Goal?> getgoal(String name) async {
    final isar = await db;

    return await isar.goals
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .titelEqualTo(name)
        .findFirstSync();
  }

  Future<Aspect?> getSepecificAspect(String name) async {
    final isar = await db;
    return isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .nameEqualTo(name)
        .findFirstSync();
  }

  Future<Habit?> getSepecificHabit(int id) async {
    final isar = await db;

    return await isar.habits
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .idEqualTo(id)
        .findFirstSync();
  }

  //updates the value of isSelected to true
  void selectAspect(String name) async {
    final isar = await db;
    Aspect? selectedAspect = await isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .nameEqualTo(name)
        .findFirst();
    selectedAspect?.isSelected = true;
    if (selectedAspect != null) {
      isar.writeTxnSync<int>(() => isar.aspects.putSync(selectedAspect));
      // update that object
    }
  }

//updates isSelected value to false for a single aspect
  void deselectAspect(String name) async {
    final isar = await db;
    Aspect? selectedAspect = await isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .nameEqualTo(name)
        .findFirst();
    selectedAspect!.isSelected = false;
    isar.writeTxnSync<int>(
        () => isar.aspects.putSync(selectedAspect)); // update that object
  }

//update the aspect points
  void updateAspectPercentage(int id, double newSum) async {
    final isar = await db;
    Aspect? updatedAspect = await isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .idEqualTo(id)
        .findFirst();
    updatedAspect!.percentagePoints = newSum;
    Imporvment newImprove = Imporvment(userID: IsarService.getUserID);
    newImprove.date = DateTime.utc(2023, 1, 17);
    newImprove.sum = newSum;
    if (newSum != 0) {
      updatedAspect.imporvmentd.add(newImprove);
    }
    isar.writeTxnSync<int>(
        () => isar.aspects.putSync(updatedAspect)); // update that object
  }

//return the isSelected value of a single aspect
  Future<bool> checkSelectionStatus(String name) async {
    final isar = await db;
    Aspect? aspect = await isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .nameEqualTo(name)
        .findFirst();
    return aspect?.isSelected ?? false;
  }

//returns a list of selected aspects
  Future<List<Aspect>> getSelectedAspects() async {
    final isar = await db;
    return await isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .isSelectedEqualTo(true)
        .findAll();
  }

  //updates the completion percentage of a task
  Future<void> updateTaskPercentage(int id, double percentage) async {
    final isar = await db;
    LocalTask? completedTask = await isar.localTasks
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .idEqualTo(id)
        .findFirst();
    completedTask!.taskCompletionPercentage = percentage;
    await isar.writeTxnSync(() => isar.localTasks.putSync(completedTask));
  }

  //change the state of completeForToday
  Future<void> completeForTodayTask(int id) async {
    final isar = await db;
    LocalTask? selected = await isar.localTasks
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .idEqualTo(id)
        .findFirst();
    //increment prgress
    selected!.amountCompleted = selected.amountCompleted + 1;
    //crossout task
    selected.completedForToday = true;
    //update task
    await isar.writeTxnSync(() => isar.localTasks.putSync(selected));
  }

  Future<void> undoCompleteForTodayTask(int id) async {
    final isar = await db;
    LocalTask? selectedLocalTask = await isar.localTasks
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .idEqualTo(id)
        .findFirst();
    //uncross task
    selectedLocalTask!.completedForToday = false;
    //decrement progress
    selectedLocalTask.amountCompleted = selectedLocalTask.amountCompleted - 1;
    await isar.writeTxnSync(() => isar.localTasks.putSync(selectedLocalTask));
  }

  //change the state of completeForToday for a habit
  Future<void> completeForTodayHabit(int id) async {
    final isar = await db;
    Habit? selected = await isar.habits
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .idEqualTo(id)
        .findFirst();
    //crossout habit
    selected!.completedForToday = true;
    //update habit
    await isar.writeTxnSync(() => isar.habits.putSync(selected));
  }

  Future<void> undoCompleteForTodayHabit(int id) async {
    final isar = await db;
    Habit? selected = await isar.habits
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .idEqualTo(id)
        .findFirst();
    //uncross a habit
    selected!.completedForToday = false;
    //update habit
    await isar.writeTxnSync(() => isar.habits.putSync(selected));
  }

  //resert check
  Future<void> reserCheck(int id) async {
    final isar = await db;
    LocalTask? selectedLocalTask = await isar.localTasks
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .idEqualTo(id)
        .findFirst();
    //uncross task
    selectedLocalTask!.completedForToday = false;
    await isar.writeTxnSync(() => isar.localTasks.putSync(selectedLocalTask));
  }

  //updates the completion percentage of a goal
  Future<void> updateGoalPercentage(int id, double percentage) async {
    final isar = await db;
    Goal? completedGoal = await isar.goals
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .idEqualTo(id)
        .findFirst();
    completedGoal!.goalProgressPercentage = percentage;
    await isar.writeTxnSync(() => isar.goals.putSync(completedGoal));
  }

//Delete //
// PENDING - as checked it cleans on app launch

  // Future<void> cleanAspects() async {
  //   final isar = await db;
  //   await isar.writeTxn(() async {
  //     await isar.aspects.clear();
  //   });
  // }

  Future<void> cleanAspects() async {
    final isar = await db;
    // not to delete all, need to delete only current user specific data
    List<Aspect> allAspects = await isar.aspects.where().findAll();
    // removing aspects of current user
    allAspects.removeWhere((aspect) => aspect.userID == IsarService.getUserID);
    await isar.writeTxnSync(() => isar.aspects.putAllSync(allAspects));
  }

// // Not a all used
//   void deleteAllAspects(List<dynamic>? aspectsChosen) async {
//     final isar = await db;
//     for (int i = 0; i < aspectsChosen!.length; i++) {
//       Aspect x = aspectsChosen[i];

//       await isar.writeTxn(() async {
//         await isar.aspects.delete(x.id);
//       });
//     }
//   }

// PENDING
  void deleteGoal(Goal goal) async {
    List<LocalTask> goalTasks = goal.task.toList();
    for (var i in goalTasks) {
      deleteTask2(i);
    }
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.goals.delete(goal.id);
    });
  }

// PENDING
  void deleteTask2(LocalTask task) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.localTasks.delete(task.id);
    });
  }

// PENDING
  void deleteHabit(Habit habit) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.habits.delete(habit.id);
    });
  }

  void UpdateGoal(Goal tem) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.goals.put(tem);
    });
  }

  void UpdateHabit(Habit tem) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.habits.put(tem);
    });
  }
}
