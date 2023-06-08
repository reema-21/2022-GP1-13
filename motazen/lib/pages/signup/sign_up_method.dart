//========this method saves the signup form data in firebase Collection (user).
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motazen/dialogue_boxes.dart';
import 'package:motazen/models/user.dart';

saveSignUpFormData(firstName, userName, email, pass, userId) async {
  try {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .set(Userr(
            firstName: firstName,
            userName: userName,
            email: email,
            password: pass,
            userID: userId,
            signInDate: DateTime.now(),
            createdCommunities: [],
            joinedCommunities: []).toJson())
        .whenComplete(
            () => Fluttertoast.showToast(msg: "تم تسجيلك بنجاح في متزن!"));
  } catch (e) {
    AllDialogues.showErrorDialog(
        discription: "حدث خطأأثناء حفظ بياناتك، الرجاء المحاولة لاحقًا.");
  }
}
