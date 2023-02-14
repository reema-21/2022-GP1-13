// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:get/get.dart';
import 'package:motazen/entities/aspect.dart';

// create  a class called task
//the class have the same name property except having a list that
// when save in here save

class c extends GetxController {
  Rx<List<dynamic>> AssesmentQuestions = Rx<List<dynamic>>([]);
  Rx<Map> AssesmentAswers = Rx<Map>({});

  Rx<List<Aspect>> PreviouseSelected = Rx<List<Aspect>>([]);

  var firstTime = false.obs;
  var showAnswere = 0;
  void storeStatusOpen(bool isOpen) {
    firstTime(isOpen);
  }
}
