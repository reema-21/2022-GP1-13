//========this method saves the signup form data in firebase Collection (user).
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motazen/dialogue_boxes.dart';

saveSignUpFormData(firstName, userName, email, pass, userId) async {
  try {
    await FirebaseFirestore.instance.collection('user').doc(userId).set({
      "first_name": firstName,
      "user_name": userName,
      "email": email,
      "pass": pass,
      "user_id": userId,
      "signin_date": DateTime.now(),
    }).whenComplete(
        () => {Fluttertoast.showToast(msg: "تم تسجيلك بنجاح في متزن!")});
  } catch (e) {
    AllDialogues.showErrorDialog(
        discription: "حدث خطأأثناء حفظ بياناتك، الرجاء المحاولة لاحقًا.");
  }
}
