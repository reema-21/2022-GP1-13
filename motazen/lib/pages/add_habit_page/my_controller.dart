import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MyControleer extends GetxController {
  var frequency = 1.obs;
  increment() {
    frequency.value++;
  }

  dcrement() {
    if (frequency.value <= 1) {
      Get.snackbar("", "قيمة التكرار لا يمكن ان تكون اقل من واحد",
          icon: const Icon(Icons.alarm), barBlur: 20);
    } else {
      frequency.value--;
    }
  }

  setvalue(int habitfrequency) {
    frequency.value = habitfrequency;
  }
}
