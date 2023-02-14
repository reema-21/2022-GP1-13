import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllDialogues {
  static showDialogue({String title = "جاري التحميل..."}) {
    Get.dialog(
      Dialog(
          clipBehavior: Clip.none,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50.0,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 20.0,
                    ),
                    const Center(
                        child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                    )),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(child: Text(title)),
                  ],
                ),
              ),
            ),
          )),
      barrierDismissible: false,
    );
  }

  static hideloading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

//======================================================================
  static showErrorDialog(
      {String title = "!حدث خطأ",
      String discription = "حدث خطأ أثناء إدخال البيانات",
      String buttonText = "حسنًا",
      double size = 60}) {
    Get.dialog(
      Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: size,
                  height: size,
                  child: const Icon(Icons.error),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Text(
                  title,
                  style:
                      Get.textTheme.headline6, //Note: change depricated element
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  discription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15.0),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (Get.isDialogOpen!) Get.back();
                  },
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
