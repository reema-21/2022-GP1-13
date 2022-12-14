// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/add_goal_page/get_chosen_aspect.dart';
import 'package:provider/provider.dart';

import '../../data/data.dart';
import '/entities/aspect.dart';
import '../../data/models.dart';
import 'select_aspect.dart';

class handle_aspect {
  final IsarService isar = IsarService();

//initialize all aspects in local storage
  Future<List<Aspect>> initializeAspects(List<Data> list) async {
    await isar.cleanAspects();
    for (var i = 0; i < list.length; i++) {
      var newAspect = Aspect();
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

  void updateAspects(Aspect aspect) {
    double aspectProgressSum = 0;
    double aspectProgressPercentage = 0;
    List<Goal> goals = aspect.goals.toList(); //the issue is probably here
    for (var element in goals) {
      aspectProgressSum = aspectProgressSum +
          (element.importance * element.goalProgressPercentage);
    }
    aspectProgressPercentage = aspectProgressSum + aspect.percentagePoints;

    if (aspectProgressPercentage <= 100) {
      IsarService().updateAspectPercentage(aspect.id, aspectProgressPercentage);
    }
  }
}

////////////////////convert from type-future to type//////////////////////////

////////////////////////////initialize for the first time/////////////////////

class initializeAspects extends StatefulWidget {
  const initializeAspects({
    super.key,
  });

  @override
  State<initializeAspects> createState() => _initializeAspectsState();
}

class _initializeAspectsState extends State<initializeAspects> {
  final IsarService isar = IsarService();
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<WheelData>(context);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: handle_aspect().initializeAspects(aspectList.data),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                aspectList.allAspects = snapshot.data!;
                return AspectSelection(
                  isr: isar,
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
  // ignore: prefer_typing_uninitialized_variables
  final page;
  const getAllAspects({super.key, required this.page});
  @override
  State<getAllAspects> createState() => _getAllAspectsState();
}

class _getAllAspectsState extends State<getAllAspects> {
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<WheelData>(context);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: handle_aspect().getAspects(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                aspectList.allAspects = snapshot.data!;
                switch (widget.page) {
                  case 'Home':
                    return getChosenAspect(
                      iser: IsarService(),
                      page: 'Home',
                      origin: '',
                    );
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
