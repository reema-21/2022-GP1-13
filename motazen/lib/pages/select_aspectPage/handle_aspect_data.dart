// ignore_for_file: camel_case_types

import '/entities/aspect.dart';
import '/isar_service.dart';
import '../../data/models.dart';

class handle_aspect {
  final IsarService isar = IsarService();

//initialize all aspects in local storage
  Future<int> initializeAspects(List<Data> list) async {
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
    return 1;
    //add a case for failure later
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

  //return a list of all selected aspects
  Future<List<Aspect>> getAspects() async {
    List<Aspect> selectedList = await isar.getAspectFirstTime();
    return selectedList;
  }

  //return a list of all selected aspects
  Future<void> setAspectpoints(String name, double point) async {
    isar.assignPointAspect(name, point);
  }
}
