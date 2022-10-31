import 'package:flutter/material.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';
import '../data/models.dart';

class handle_aspect {
  late IsarService isar;

//initialize all aspects in local storage
  void initializeAspects(List<Data> list) {
    isar.cleanAspects();
    final newAspect = Aspect();
    for (var i = 0; i < list.length + 1; i++) {
      newAspect
        ..name = list[i].name
        ..isSelected = false
        ..color = list[i].color
        ..percentagePoints = list[i].points
        ..iconCodePoint = list[i].icon.codePoint
        ..iconFontFamily = list[i].icon.fontFamily
        ..iconFontPackage = list[i].icon.fontPackage
        ..iconDirection = list[i].icon.matchTextDirection;
    }
    isar.createAspect(newAspect);
  }

  //update aspect status
  void updateStatus(String name) {
    //check status
    bool status = isar.checkSelectionStatus(name) as bool;
    switch (status) {
      case false:
        isar.selectAspect(name);
        break;
      case true:
        isar.deselectAspect(name);
        break;
    }
  }

  //return aspect color
  Color getAspectColor(String name) {
    bool aspectStatus = isar.checkSelectionStatus(name) as bool;
    int aspectColor = isar.getAspectColor(name) as int;

    if (aspectStatus) {
      //for selected aspects
      return Color(aspectColor).withOpacity(1);
    } else {
      // for deselected aspects
      return Color(aspectColor).withOpacity(0.18);
    }
  }

//return a list of all selected aspects
  List<Aspect> getSelectedAspects() {
    List<Aspect> selectedList = isar.getSelectedAspects() as List<Aspect>;
    return selectedList;
  }
}
