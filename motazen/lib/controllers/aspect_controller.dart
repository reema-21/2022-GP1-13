import 'package:flutter/material.dart';
import 'package:motazen/entities/goal.dart';
import '/entities/aspect.dart';
import 'package:motazen/models/aspect_model.dart';

class AspectController with ChangeNotifier {
  //it might be better to save directly from DB
  List<AspectModel> data = [
    //add friends and family aspect
    AspectModel(name: 'عائلتي واصدقائي', color: 4294938880, icon: Icons.person),
    //add صحتي aspect
    AspectModel(name: 'صحتي', color: 4294956032, icon: Icons.spa),
    //add ذاتي aspect
    AspectModel(name: 'ذاتي', color: 4281130443, icon: Icons.psychology),
    //add بيئتي aspect
    AspectModel(name: 'بيئتي', color: 4288551408, icon: Icons.home),
    //add علاقاتي aspect
    AspectModel(name: 'علاقاتي', color: 4294920521, icon: Icons.favorite),
    //add مهنتي aspect
    AspectModel(name: 'مهنتي', color: 4278216099, icon: Icons.work),
    //add متعتي aspect
    AspectModel(name: 'متعتي', color: 4278225631, icon: Icons.games),
    //add أموالي aspect
    AspectModel(name: 'أموالي', color: 4283753312, icon: Icons.attach_money),
  ];
  List<Aspect> allAspects = [];
  List<Aspect> selected = [];
  List<Goal> goalList = [];
  List questionData = [];

  List<Goal> getgoals(Aspect aspect) {
    List<Goal> goals = [];
    if (selected.contains(aspect)) {
      for (var goal in aspect.goals.toList()) {
        goals.add(goal);
      }
    }
    return goals;
  }

  contains(String s) {
    for (var i = 0; i < data.length; i++) {
      if (data[i].name == s) {
        return true;
      }
    }
    return false;
  }

  //update selected
  void updateSelectedList(List<Aspect> newSelected) {
    selected.clear();
    selected.addAll(newSelected);
  }

  //clear question answers
  void clearQuestiondData() {
    questionData.clear();
    notifyListeners();
  }

  //return the names of the aspects
  List<String> getSelectedNames() {
    List<String> names = [];
    for (var aspect in selected) {
      names.add(aspect.name);
    }
    return names;
  }

  Icon getSelectedIcon(String name, {double? size}) {
    Icon icon = Icon(
      Icons.place,
      size: size ?? 24.0,
    );
    for (var aspect in allAspects) {
      if (name == aspect.name) {
        icon = Icon(
          IconData(aspect.iconCodePoint,
              fontFamily: aspect.iconFontFamily,
              fontPackage: aspect.iconFontPackage,
              matchTextDirection: aspect.iconDirection),
          color: Color(aspect.color),
          size: size ?? 24.0,
        );
      }
    }
    return icon;
  }

  getColor(String name) {
    List<Aspect> temp = selected;
    for (var aspect in temp) {
      if (name == aspect.name) {
        return aspect.color;
      }
    }
  }

  void updateQuestionData(List questions) {
    //Step1: if the aspect was previously selected, update  the points value
    for (var newItem in questions) {
      for (var oldItem in questionData) {
        if (newItem['question'] == oldItem['question']) {
          newItem['points'] = oldItem['points'];
        }
      }
    }
    //step2: update the provider list
    questionData = questions;
  }

  Color getSelectedColor(String name) {
    late Color color;
    for (var aspect in selected) {
      if (name == aspect.name) {
        color = Color(aspect.color);
      }
    }
    return color;
  }
}
