// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:motazen/Sidebar_and_navigation/navigation-bar.dart';
import 'package:provider/provider.dart';

import '../../data/data.dart';
import '/entities/aspect.dart';
import '/isar_service.dart';
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
                  aspects: aspectList.allAspects,
                );
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}

//////////////////////////////// fetch aspects from local storage///////////////////////
class getAllAspects extends StatefulWidget {
  const getAllAspects({super.key});

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
                return const navBar();
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
