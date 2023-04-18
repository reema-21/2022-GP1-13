import 'package:flutter/material.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/add_goal_page/get_chosen_aspect.dart';
import 'package:provider/provider.dart';
import '../../controllers/aspect_controller.dart';
import '/entities/aspect.dart';
import '../../models/aspect_model.dart';
import 'select_aspect.dart';

class HandleAspect {
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

  Future<void> updateAspects(Aspect aspect, Goal goal,
      double previousGoalProgress, double newGoalProgress) async {
    double aspectImprovement = 0;
    double newAspectPoints = 0;
    double aspectCurrentPoint = aspect.percentagePoints;

    ///Remove previous goal progress if any for a more accurate result
    aspectCurrentPoint =
        aspectCurrentPoint - (goal.importance * previousGoalProgress);

    ///save the improvement (change in points) for the linechart
    ///Note: does it need to be stored every time, the list becomes too big
    aspectImprovement = goal.importance * newGoalProgress;
    await IsarService().addImprovement(aspectImprovement, aspect: aspect);

    //calculate the new points value
    newAspectPoints = aspectImprovement + aspectCurrentPoint;

    //only save the current value if it's within range
    if (newAspectPoints <= 100) {
      await IsarService().updateAspectPercentage(aspect.id, newAspectPoints);
    }
  }
}

//------------------------convert from type-future to type------------------------//

//------------------------initialize for the first time------------------------//

class InitializeAspects extends StatefulWidget {
  final bool? isRetake;
  const InitializeAspects({
    super.key,
    this.isRetake,
  });

  @override
  State<InitializeAspects> createState() => _InitializeAspectsState();
}

class _InitializeAspectsState extends State<InitializeAspects> {
  final IsarService isar = IsarService();
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Aspect>>(
            future: HandleAspect().initializeAspects(aspectList.data),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                aspectList.allAspects = snapshot.data!;
                return AspectSelection(
                  isRetake: widget.isRetake,
                  previousAspects: aspectList.allAspects,
                );
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}

//------------------------ fetch aspects from local storage then------------------------//
class GetAllAspects extends StatefulWidget {
  final String page;
  const GetAllAspects({super.key, required this.page});
  @override
  State<GetAllAspects> createState() => _GetAllAspectsState();
}

class _GetAllAspectsState extends State<GetAllAspects> {
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: HandleAspect().getAspects(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                aspectList.allAspects = snapshot.data!;
                switch (widget.page) {
                  case 'Home':
                    return const GetChosenAspect();
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
