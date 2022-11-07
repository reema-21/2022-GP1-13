// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/pages/reset/verify.dart';
import 'package:motazen/primary_button.dart';
import 'package:motazen/theme.dart';

import '../../dialogue_boxes.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController first_name_controller = TextEditingController();
  TextEditingController user_name_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controler = TextEditingController();
  TextEditingController conform_password_controller = TextEditingController();
  final _SignUpformKey = GlobalKey<FormState>();

  bool pass_isObscures = true;
  bool conform_pass_isObscure = true;

  Future<bool> usernameCheck(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('user')
        .where('user_name', isEqualTo: username)
        .get();
    return result.docs.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _SignUpformKey,
          child: Column(
            children: <Widget>[
              // //=========1========first name field===============
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                      controller: user_name_controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'فضلًا ادخل اسم المستخدم، مثل: motazen1';
                        }
                        if (value.length > 16 || value.length < 4) {
                          return "اسم المستخدم يجب أن يكون بين 4-16 خانة";
                        }
                        int nums = 0;
                        for (int i = 0; i < value.length; i++) {
                          if (value[i] == '0' ||
                              value[i] == '1' ||
                              value[i] == '2' ||
                              value[i] == '3' ||
                              value[i] == '4' ||
                              value[i] == '5' ||
                              value[i] == '6' ||
                              value[i] == '7' ||
                              value[i] == '8' ||
                              value[i] == '9') {
                            nums += 1;
                          }
                        }
                        if (nums > 7) {
                          return "اسم المستخدم لا يمكن أن يحتوي على أكثر من 7 أرقام";
                        }
                        if (!RegExp(r"^[A-Za-z0-9]*$").hasMatch(value)) {
                          return "اسم المستخدم يقبل الحروف والأعداد الإنجليزية دون الرموز.";
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'اسم المستخدم',
                        labelStyle: TextStyle(
                          color: kTextFieldColor,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                      ))),
              // //========2=========user name field===============
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                      controller: first_name_controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'فضلًا ادخل اسمك مثل: محمد';
                        }
                        if (!RegExp(r"^[\u0600-\u06FF ]+").hasMatch(value)) {
                          return "ادخلك اسمك باللغة العربية وليس بلغةٍ أخرى"; //
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'الاسم الخاص بك',
                        labelStyle: TextStyle(
                          color: kTextFieldColor,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                      ))),
              // //========3=========email field===============
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                      controller: email_controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'فضلًا ادخل بريدك الإلكتروني';
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          // [،-٩]+
                          return "البريد الإلكتروني غير صحيح";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        labelStyle: TextStyle(
                          color: kTextFieldColor,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                      ))),

              //=======4=======password field'======================
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  controller: password_controler,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'فضلًا ادخل كلمة السر';
                    }
                    if (value.length < 6) {
                      return 'كلمة السر يجب أن تكون 6 خانات فأكثر مثل:IH2D45f';
                    }
                    return null;
                  },
                  obscureText: pass_isObscures ? true : false,
                  decoration: InputDecoration(
                      labelText: 'كلمة السر',
                      labelStyle: const TextStyle(
                        color: kTextFieldColor,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            pass_isObscures = !pass_isObscures;
                          });
                        },
                        icon: pass_isObscures
                            ? const Icon(
                                Icons.visibility_off,
                                color: kTextFieldColor,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: kPrimaryColor,
                              ),
                      )),
                ),
              ),
              //=======5=======conform password field'======================
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  controller: conform_password_controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'فضلا ادخل كلمة السر';
                    }
                    if (value != password_controler.text) {
                      return "كلمة السر لا تتطابق";
                    }
                    return null;
                  },
                  obscureText: conform_pass_isObscure ? true : false,
                  decoration: InputDecoration(
                      labelText: 'تأكيد كلمة السر',
                      labelStyle: const TextStyle(
                        color: kTextFieldColor,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            conform_pass_isObscure = !conform_pass_isObscure;
                          });
                        },
                        icon: conform_pass_isObscure
                            ? const Icon(
                                Icons.visibility_off,
                                color: kTextFieldColor,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: kPrimaryColor,
                              ),
                      )),
                ),
              ),
              //=====form ends here========
            ],
          ),
        ),
        //form ends here ==========
        //==================================sign up button==========
        const SizedBox(
          height: 40,
        ),
        InkWell(
          onTap: () async {
            if (_SignUpformKey.currentState!.validate()) {
              AllDialogues.showDialogue(title: "جاري التحميل...");
              final validUserName =
                  await usernameCheck(user_name_controller.text.toLowerCase());
              //======after validation the form I navigate the user for email verification in the verify screen in reset folder.
              // ====by using the Get.to method. //make sure it is in the yaml class in the motazen share code
              AllDialogues.hideloading();
              if (!validUserName) {
                AllDialogues.showErrorDialog(
                    title: "!هذا المستخدم مسجل سابقًا",
                    discription:
                        " مسجل سابقًا، سجّل باسم مستخدم جديد ${user_name_controller.text} ");
              } else {
                await Get.to(VerifyScreen(
                  first_name: first_name_controller.text,
                  user_name: user_name_controller.text.toLowerCase(),
                  email: email_controller.text,
                  pass: password_controler.text,
                ));
              }
            }
          },
          child: const PrimaryButton(buttonText: 'إنشاء حساب'),
        )
      ],
    );
  }
}
