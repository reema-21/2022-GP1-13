import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:motazen/entities/community_id.dart';
import 'package:motazen/entities/imporvment.dart';
import 'package:motazen/entities/local_task.dart';
import 'package:motazen/theme.dart';
import '/entities/aspect.dart';
import '/entities/goal.dart';
import '/entities/habit.dart';
import 'package:isar/isar.dart';
import 'controllers/community_controller.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;
  IsarService() {
    db = openIsar();
  }
  static String get getUserID => FirebaseAuth.instance.currentUser?.email ?? "";

  Future<Isar> openIsar() async {
    final dir = await getApplicationDocumentsDirectory();
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
          inspector: true,
          directory: dir.path);
    }
    return Future.value(Isar.getInstance());
  }

  /// ADD GOALS , ADD TASKS , ADD ASPECT  */
  Future<int> createGoal(Goal newgoal) async {
    //Add goals
    final isar = await db;
    return isar.writeTxnSync<int>(() => isar.goals.putSync(newgoal));
  } //<int> because we want to get the id of the  ceated thing

  Future<void> linkGoalAndTasks(int goalId, List<LocalTask> tasks) async {
    //Add goals
    final isar = await db;
    Goal? goal = await getSepecificGoall(goalId);
    isar.writeTxnSync(() {
      // first create the goal
      goal!.task.addAll(tasks);
      goal.task.saveSync();

      for (var task in tasks) {
        task.goal.value = goal;
        task.goal.saveSync();
      }
    });
  }

  void updateTask(LocalTask tem) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.localTasks.put(tem);
    });
  }

  Future<void> addAspectHabitLink(Habit habit, Aspect aspect) async {
    //create the link
    aspect.habits.add(habit);
    final isar = await db;
    //save the link
    isar.writeTxnSync(() {
      aspect.habits.saveSync();
    });
  }

  Future<LocalTask?> findSepecificTaskByID(int id) async {
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

  void deleteTask(LocalTask task) async {
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

  Future<void> createCommunity(CommunityID newCommunity) async {
    //Add habits
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.communityIDs.putSync(newCommunity));
  }

  Future<bool> createAspect(Aspect newAspect) async {
    final isar = await db;
    //Step1: check if the aspect exists for the user (avoid duplication)
    Aspect? aspect = await isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .nameEqualTo(newAspect.name)
        .findFirst();

    if (aspect == null) {
      //Step2: if there is no duplication save the aspect
      isar.writeTxnSync<int>(() => isar.aspects.putSync(newAspect));
      return true;
    } else {
      //Alt Step2: if there is duplication, do not save and return false
      return false;
    }
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
    isar.writeTxn(() async => await isar.aspects.put(tempAspect));
  }

  Future<void> addImprovement(double points,
      {Aspect? aspect, String? aspectName}) async {
    final isar = await db;
    if (aspectName != null || aspect == null) {
      aspect = await findSepecificAspect(aspectName!);
    }

    Imporvment newImprove = Imporvment(userID: IsarService.getUserID);
    isar.writeTxn(() async {
      newImprove.date = DateTime.now();
      newImprove.sum = points;
      await isar.imporvments.put(newImprove);
      aspect!.imporvmentd.add(newImprove);
      await aspect.imporvmentd.save();
    });
  }

  Future<void> removeAspectImprovement(String aspectName) async {
    final isar = await db;
    Aspect aspect = Aspect(userID: IsarService.getUserID);
    aspect = (await findSepecificAspect(aspectName))!;
    List<Imporvment> aspectImprovements = aspect.imporvmentd.toList();
    isar.writeTxn(() async {
      for (var improvement in aspectImprovements) {
        await isar.imporvments.delete(improvement.id);
      }
    });
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

  Future<void> saveCom(CommunityID task) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.communityIDs.putSync(task));
  }

  Future<void> addAspectGoalLink(Goal goal, Aspect aspect) async {
    //create the link
    aspect.goals.add(goal);
    final isar = await db;
    //save the link
    isar.writeTxnSync(() {
      aspect.goals.saveSync();
    });
  }

  // Future<void> updateTaskSync(LocalTask task) async {
  //   final isar = await db;
  //   isar.writeTxnSync<int>(() => isar.localTasks.putSync(task));
  // }

  Future<void> deleteTaskByIdSync(int id) async {
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
      return isar.goals
          .filter()
          .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
          .idEqualTo(id);
    });
    return null;
  }

  Future<Aspect?> getAspectByGoal(int goalId) async {
    final isar = await db;

    return isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .goals((q) => q.idEqualTo(goalId))
        .findFirstSync();
  }

  Future<Goal?> getSepecificGoall(int id) async {
    final isar = await db;

    return isar.goals
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .idEqualTo(id)
        .findFirstSync();
  }

  Future<Goal?> getgoal(String name) async {
    final isar = await db;

    return isar.goals
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

    return isar.habits
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .idEqualTo(id)
        .findFirstSync();
  }

  //updates the value of isSelected to true
  Future<bool> selectAspect(String name) async {
    final isar = await db;
    Aspect? selectedAspect = await isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .nameEqualTo(name)
        .findFirst();
    selectedAspect?.isSelected = true;
    if (selectedAspect != null) {
      await isar.writeTxn(() async => await isar.aspects.put(selectedAspect));
    }
    return true;
  }

//updates isSelected value to false for a single aspect
  Future<bool> deselectAspect(String name) async {
    final isar = await db;
    Aspect? selectedAspect = await isar.aspects
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .nameEqualTo(name)
        .findFirst();
    selectedAspect!.isSelected = false;
    await isar.writeTxn(() async => await isar.aspects.put(selectedAspect));
    return true;
  }

//update the aspect points
  Future<void> updateAspectPercentage(int id, double newSum) async {
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
    isar.writeTxn<int>(() async =>
        await isar.aspects.put(updatedAspect)); // update that object
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

//returns a list of selected aspects
  Future<List<LocalTask>> getAllTasks() async {
    final isar = await db;
    return await isar.localTasks
        .filter()
        .userIDEqualTo(IsarService.getUserID, caseSensitive: true)
        .findAll();
  }

  Future<void> updateTaskRank(int id, double rank) async {
    final isar = await db;
    await isar.writeTxn(() async {
      LocalTask? task = await findSepecificTaskByID(id);
      if (task == null) {
        log('Error: task is null, id = $id');
        return;
      }
      task.rank = rank;
      await isar.localTasks.put(task);
    });
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

    isar.writeTxn(() async => await isar.localTasks.put(completedTask));
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
    //set last completion date
    selected.lastCompletionDate = DateTime.now();
    //update task

    await isar.writeTxn(() async => await isar.localTasks.put(selected));
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

    await isar
        .writeTxn(() async => await isar.localTasks.put(selectedLocalTask));
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

    isar.writeTxnSync(() => isar.habits.putSync(selected));
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

    await isar.writeTxn(() async => await isar.habits.put(selected));
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

    isar.writeTxnSync(() => isar.localTasks.putSync(selectedLocalTask));
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
    isar.writeTxn(() async => await isar.goals.put(completedGoal));
    if (completedGoal.communities.isNotEmpty) {
      List<dynamic> publicCommunities = completedGoal.communities.toList();

      //!there is a chance of an error if the community is private there will be
      //so here we first need to know if this goal is shared in private or puublic community and the fetch the progress list in the right collection :)
//first get the community id

      for (int v = 0; v < publicCommunities.length; v++) {
        //first get the community by id

        dynamic communityDoc;
        communityDoc = await firestore
            .collection('public_communities')
            .doc(publicCommunities[v].communityId)
            .get();
        if (communityDoc.data() != null) {
          final currentCommunityDoc = communityDoc.data()! as dynamic;

          final user = FirebaseAuth.instance.currentUser!.uid;
          List communities = [];
          communities = currentCommunityDoc['progress_list'];
          for (int i = 0; i < communities.length; i++) {
            if (communities[i][user] != null) {
              currentCommunityDoc['progress_list'][i][user] = percentage;

              await firestore
                  .collection('public_communities')
                  .doc(publicCommunities[v].communityId)
                  .update({
                'progress_list': currentCommunityDoc['progress_list'],
              });
            }
          }
        } else {
          //meanig it is a private community
          communityDoc = await firestore
              .collection('private_communities')
              .doc(publicCommunities[v].communityId)
              .get();
          final currentCommunityDoc = communityDoc.data()! as dynamic;

          final user = FirebaseAuth.instance.currentUser!.uid;
          List communities = [];
          communities = currentCommunityDoc['progress_list'];
          for (int i = 0; i < communities.length; i++) {
            if (communities[i][user] != null) {
              currentCommunityDoc['progress_list'][i][user] = percentage;

              await firestore
                  .collection('private_communities')
                  .doc(publicCommunities[v].communityId)
                  .update({
                'progress_list': currentCommunityDoc['progress_list'],
              });
            }
          }
        }
      }
    }
  }

  Future<void> cleanAspects() async {
    final isar = await db;
    // not to delete all, need to delete only current user specific data
    List<Aspect> allAspects = await isar.aspects.where().findAll();
    // removing aspects of current user
    allAspects.removeWhere((aspect) => aspect.userID == IsarService.getUserID);

    isar.writeTxnSync(() => isar.aspects.putAllSync(allAspects));
  }

  Future<void> cleanTasks() async {
    final isar = await db;
    // not to delete all, need to delete only current user specific data
    await isar.writeTxn(() async => await isar.localTasks.clear());
  }

// PENDING
  void deleteGoal(Goal goal) async {
    List<LocalTask> goalTasks = goal.task.toList();
    for (var i in goalTasks) {
      deleteTaskByIdAsync(i);
    }
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.goals.delete(goal.id);
    });
  }

  //! if everything will be deleted then i think i should delete everything with the username .
  void deleteAllAspectsData(String name) async {
    Aspect? aspect = await getSepecificAspect(name);

    final isar = await db;
    //* Delete goals and related tasks
    await isar.writeTxn(() async {
      //get the ids of goal related to the sendedaspect ;
      List<Goal> allGoal = await isar.goals
          .where()
          .filter()
          .aspect((q) => q.nameEqualTo(aspect!.name))
          .findAll();
      allGoal.removeWhere((goal) => goal.userID != IsarService.getUserID);

      List<int> ids = [];
      for (var element in allGoal) {
        List<LocalTask> allTasks = await isar.localTasks
            .where()
            .filter()
            .goal((q) => q.idEqualTo(element.id))
            .findAll();
        allTasks.removeWhere((task) => task.userID != IsarService.getUserID);
        List<int> tasksIds = [];
        for (var element in allTasks) {
          tasksIds.add(element.id);
        }
        await isar.localTasks.deleteAll(tasksIds);

//*Community
        List<CommunityID> allCommunities = await isar.communityIDs
            .where()
            .filter()
            .goal((q) => q.idEqualTo(element.id))
            .findAll();
        allCommunities
            .removeWhere((com) => com.userID != IsarService.getUserID);
        List<int> comIds = [];
        for (var element in allCommunities) {
          comIds.add(element.id);
        }
        await isar.communityIDs.deleteAll(comIds);

        ids.add(element.id);
      }
      await isar.goals.deleteAll(ids);

      //*Delete habits
      List<Habit> allHabits = await isar.habits
          .where()
          .filter()
          .aspect((q) => q.nameEqualTo(aspect!.name))
          .findAll();
      allHabits.removeWhere((habit) => habit.userID != IsarService.getUserID);

      List<int> habitIds = [];
      for (var element in allHabits) {
        habitIds.add(element.id);
      }

      await isar.habits.deleteAll(habitIds);
    });

//* try to remove from firebase the communituys relate to the aspect
    CommunityController communityController = Get.find();

//! you need to mark it as deleted for others
    for (var element in communityController.listOfCreatedCommunities) {
      if (element.aspect == aspect!.name) {
        dynamic communityDoc;

        if (element.isPrivate) {
          await firestore
              .collection('private_communities')
              .doc(element.id)
              .update({'isDeleted': true});
          communityDoc = await firestore
              .collection('private_communities')
              .doc(element.id)
              .get();
          final cuurentCommunityDoc = communityDoc.data()! as dynamic;
          List progressList = cuurentCommunityDoc['progress_list'];
          for (int i = 0; i < progressList.length; i++) {
            String x = progressList[i].toString();
            String userId = x.substring(1, x.indexOf(':'));
            dynamic userDoc =
                await firestore.collection("user").doc(userId).get();
            final users = userDoc.data()! as dynamic;
            List join = users["joinedCommunities"];
            //try to use joinedCommunitiess in the authcontroller
            for (int i = 0; i < join.length; i++) {
              if (join[i]["_id"] == element.id) {
                join[i]["isDeleted"] = true;
                await firestore
                    .collection('user')
                    .doc(userId)
                    .update({'joinedCommunities': join});
              }
            }
          }
        } else {
          await firestore
              .collection('public_communities')
              .doc(element.id)
              .update({'isDeleted': true});
          communityDoc = await firestore
              .collection('public_communities')
              .doc(element.id)
              .get();
          final cuurentCommunityDoc = communityDoc.data()! as dynamic;
          List progressList = cuurentCommunityDoc['progress_list'];
          for (int i = 0; i < progressList.length; i++) {
            String x = progressList[i].toString();
            String userId = x.substring(1, x.indexOf(':'));
            dynamic userDoc =
                await firestore.collection("user").doc(userId).get();
            final users = userDoc.data()! as dynamic;
            List join = users["joinedCommunities"];
            //try to use joinedCommunitiess in the authcontroller
            for (int i = 0; i < join.length; i++) {
              if (join[i]["_id"] == element.id) {
                join[i]["isDeleted"] = true;
                await firestore
                    .collection('user')
                    .doc(userId)
                    .update({'joinedCommunities': join});
              }
            }
          }
        }
      }
    }
// end of that do it after making sire it is all delted for mth e cureent user
    communityController.listOfJoinedCommunities
        .removeWhere((element) => element.aspect == aspect!.name);
    await firestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'joinedCommunities': communityController.listOfJoinedCommunities
          .map((e) => {
                'aspect': e.aspect,
                'communityName': e.communityName,
                'creationDate': e.creationDate,
                'progress_list': e.progressList,
                'founderUsername': e.founderUsername,
                'goalName': e.goalName,
                'isPrivate': e.isPrivate,
                "isDeleted": e.isDeleted,
                '_id': e.id
              })
          .toList(),
    });
    communityController.listOfCreatedCommunities
        .removeWhere((element) => element.aspect == aspect!.name);
    await firestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'createdCommunities': communityController.listOfCreatedCommunities
          .map((e) => {
                'aspect': e.aspect,
                'communityName': e.communityName,
                'creationDate': e.creationDate,
                'founderUsername': e.founderUsername,
                'goalName': e.goalName,
                'isPrivate': e.isPrivate,
                'progress_list': e.progressList,
                '_id': e.id,
                "isDeleted": e.isDeleted
              })
          .toList(),
    });
  }

// PENDING
  void deleteTaskByIdAsync(LocalTask task) async {
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

  void updateGoal(Goal tem) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.goals.put(tem);
    });
  }

  void updateHabit(Habit tem) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.habits.put(tem);
    });
  }
}
