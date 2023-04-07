// ignore_for_file: camel_case_types
//manar
import 'package:flutter/material.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/add_goal_page/get_chosen_aspect.dart';
import 'package:provider/provider.dart';
import '../../controllers/aspect_controller.dart';
import '/entities/aspect.dart';
import '../../models/aspect_model.dart';
import 'select_aspect.dart';

class handle_aspect {
  final IsarService isar = IsarService();

//initialize all aspects in local storage
  Future<List<Aspect>> initializeAspects(List<AspectModel> list) async {
    await isar.cleanAspects();
    for (var i = 0; i < list.length; i++) {
      var newAspect = Aspect(userID: IsarService.getUserID);
      newAspect
        ..name = list[i].name
        ..isSelected = false
        ..color = list[i].color
        ..percentagePoints = list[i].points
        ..iconCodePoint = list[i].icon.codePoint
        ..iconFontFamily = list[i].icon.fontFamily
        ..iconFontPackage = list[i].icon.fontPackage
        ..iconDirection = list[i].icon.matchTextDirection;
      await isar.createAspect(newAspect);
    }
    List<Aspect> aspects = await isar.getAspectFirstTime();
    return aspects;
  }

  //update aspect status
  Future<void> updateStatus(String name) async {
    //check status
    bool status = await isar.checkSelectionStatus(name);
    switch (status) {
      case false:
        isar.selectAspect(name);
        break;
      case true:
        isar.deselectAspect(name);

        break;
    }
  }

//return a list of all selected aspects
  Future<List<Aspect>> getSelectedAspects() async {
    List<Aspect> selectedList = await isar.getSelectedAspects();
    return selectedList;
  }

  //return a list of all aspects
  Future<List<Aspect>> getAspects() async {
    List<Aspect> list = await isar.getAspectFirstTime();
    return list;
  }

  //return a list of all selected aspects
  Future<void> setAspectpoints(String name, double point) async {
    isar.assignPointAspect(name, point);
  }

  void updateAspects(Aspect aspect, Goal goal, double previousGoalProgress,
      double newGoalProgress) {
    double aspectImprovement = 0;
    double newAspectPoints = 0;
    double aspectCurrentPoint = aspect.percentagePoints;

    ///Remove previous goal progress if any for a more accurate result
    aspectCurrentPoint =
        aspectCurrentPoint - (goal.importance * previousGoalProgress);

    ///save the improvement (change in points) for the linechart
    ///Note: does it need to be stored every time, the list becomes too big
    aspectImprovement = goal.importance * newGoalProgress;

    //calculate the new points value
    newAspectPoints = aspectImprovement + aspectCurrentPoint;

    //only save the current value if it's within range
    if (newAspectPoints <= 100) {
      IsarService().updateAspectPercentage(aspect.id, newAspectPoints);
    }
  }
}

////////////////////convert from type-future to type//////////////////////////

////////////////////////////initialize for the first time/////////////////////

class initializeAspects extends StatefulWidget {
  final bool? isRetake;
  const initializeAspects({
    super.key,
    this.isRetake,
  });

  @override
  State<initializeAspects> createState() => _initializeAspectsState();
}

class _initializeAspectsState extends State<initializeAspects> {
  final IsarService isar = IsarService();
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Aspect>>(
            future: handle_aspect().initializeAspects(aspectList.data),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                aspectList.allAspects = snapshot.data!;
                return AspectSelection(
                  isRetake: widget.isRetake,
                );
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}

//////////////////////////////// fetch aspects from local storage then///////////////////////
class getAllAspects extends StatefulWidget {
  final String page;
  const getAllAspects({super.key, required this.page});
  @override
  State<getAllAspects> createState() => _getAllAspectsState();
}

class _getAllAspectsState extends State<getAllAspects> {
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: handle_aspect().getAspects(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                aspectList.allAspects = snapshot.data!;
                switch (widget.page) {
                  case 'Home':
                    return const getChosenAspect();
                  default:
                    throw 'Error404: page not found';
                }
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
