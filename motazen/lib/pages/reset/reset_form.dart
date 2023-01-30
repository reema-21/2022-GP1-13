// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:motazen/dialogue_boxes.dart';
import 'package:motazen/pages/login/login.dart';
import 'package:motazen/primary_button.dart';
import 'package:motazen/theme.dart';

class ResetForm extends StatefulWidget {
  const ResetForm({super.key});

  @override
  State<ResetForm> createState() => _ResetFormState();
}

class _ResetFormState extends State<ResetForm> {
  final _resetformKey = GlobalKey<FormState>();
  TextEditingController reset_pass_email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Form(
        key: _resetformKey,
        child: Column(
          children: <Widget>[
            // //=================first name field===============
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                    controller: reset_pass_email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'فضلا ادخل بريدك الإلكتروني، مثل: motazen@gmail.com';
                      }
                      if (!value.contains("@")) {
                        return "البريد الإلكتروني غير صحيح";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'ادخل البريد الإلكتروني',
                      labelStyle: TextStyle(
                        color: kTextFieldColor,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                    ))),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () async {
                if (_resetformKey.currentState!.validate()) {
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: reset_pass_email.text);
                    Get.to(() => const LogInScreen());
                    AllDialogues.showErrorDialog(
                        title: "إعادة ضبط كلمة السر",
                        discription:
                            " سوف يرسل رابط عن طريق بريدك الخاص من خلاله تستطيع إعادة ضبط كلمة السر، في حال عدم وصوله قد تجده في الرسائل المزعجة (spam)");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      Fluttertoast.showToast(
                          msg:
                              'لا يوجد مستخدم مسجل مسبقا بهذا البريد، الرجاء المحاولة مجددا');
                    }
                  }
                }
              },
              child: const PrimaryButton(
                buttonText: 'التالي',
              ),
            )
          ],
        ),
      ),
    );
  }
}
