import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/community_controller.dart';
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
    double aspectCurrentPoint = aspect.percentagePoints;

    // Remove previous goal progress if any for a more accurate result
    aspectCurrentPoint -= goal.importance * previousGoalProgress;

    // Save the improvement (change in points) for the line chart
    await IsarService()
        .addImprovement(goal.importance * newGoalProgress, aspect: aspect);

    // Calculate the new points value
    double newAspectPoints =
        goal.importance * newGoalProgress + aspectCurrentPoint;

    // Exit early if the new points value is out of range
    if (newAspectPoints > 100) {
      return;
    }

    // Update the aspect percentage value
    await IsarService().updateAspectPercentage(aspect.id, newAspectPoints);
  }
}

//------------------------convert from type-future to type------------------------//

//------------------------initialize for the first time------------------------//
class InitializeAspects extends StatefulWidget {
  final bool? isRetake;
  const InitializeAspects({
    Key? key,
    this.isRetake,
  }) : super(key: key);

  @override
  State<InitializeAspects> createState() => _InitializeAspectsState();
}

class _InitializeAspectsState extends State<InitializeAspects> {
  final IsarService isar = IsarService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Aspect>>(
          future: HandleAspect()
              .initializeAspects(context.read<AspectController>().data),
          builder: (context, snapshot) {
            final aspectList = context.watch<AspectController>();
            if (snapshot.hasData) {
              aspectList.allAspects = snapshot.data!;
              return AspectSelection(
                isRetake: widget.isRetake,
                previousAspects: aspectList.allAspects,
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
} //------------------------ fetch aspects from local storage then------------------------//

class GetAllAspects extends StatefulWidget {
  final String page;
  const GetAllAspects({Key? key, required this.page}) : super(key: key);

  @override
  State<GetAllAspects> createState() => _GetAllAspectsState();
}

class _GetAllAspectsState extends State<GetAllAspects> {
  final CommunityController communityController =
      Get.put(CommunityController());

  @override
  void initState() {
    super.initState();
    communityController.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Aspect>>(
          future: HandleAspect().getAspects(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                aspectList.allAspects = snapshot.data!;
                switch (widget.page) {
                  case 'Home':
                    return const GetChosenAspect();
                  default:
                    return const Text('Error 404: Page not found');
                }
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
