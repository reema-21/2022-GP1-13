// ignore_for_file: must_be_immutable, non_constant_identifier_names, await_only_futures

import 'dart:async';

import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:motazen/dialogue_boxes.dart';
import 'package:motazen/pages/signup/sign_up_method.dart';
import 'package:motazen/pages/signup/signup.dart';
import 'package:motazen/primary_button.dart';
import 'package:motazen/theme.dart';

import '../../data/data.dart';
import '../assesment_page/alert_dialog.dart';

class VerifyScreen extends StatefulWidget {
  //======= this data is received from sign up form.
  final String first_name;
  final String user_name;
  String email;
  final String pass;
  VerifyScreen(
      {Key? key,
      this.first_name = "",
      this.user_name = "",
      this.email = "",
      this.pass = ""})
      : super(key: key);
  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final otpformkey = GlobalKey<FormState>();
  TextEditingController otpTextfield = TextEditingController();
  EmailAuth emailAuth = EmailAuth(sessionName: "motazen");

  //=====================timer
  int _counter = 60;
  // late Timer _timer;
  late Timer _timer;
  void _startTimer() {
    _counter = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    sendOtp();
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor.withOpacity(0),
        iconTheme: const IconThemeData(
          color: kBlackColor,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 120,
                ),
                Text(
                  'التحقق من بريدك الإلكتروني',
                  style: titleText.copyWith(
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '2) ادخل الرمز المرسل عبر بريدك:',
                  style: subTitle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text('رمز (OTP) قد تم ارساله عبر بريدك المسجل ',
                    style: TextStyle(fontSize: 14)),
                const SizedBox(
                  height: 10,
                ),
                //=================otp field===============================
                Form(
                  key: otpformkey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: otpTextfield,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'فضلا ادخل الرمز المُرسل';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'ادخل الرمز',
                          hintStyle: TextStyle(color: kTextFieldColor),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor))),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ادخل الرمز خلال:',
                      style: TextStyle(fontSize: 16, color: kBlackColor),
                    ),
                    Text(
                      _counter.toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: kBlackColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    //==this button a verify otp function
                    if (otpformkey.currentState!.validate()) {
                      verifyEmail();
                    } else {
                      // Fluttertoast.showToast(msg: "Invalid OTP.");
                    }
                  },
                  child: const PrimaryButton(
                    buttonText: 'تأكيد',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    AllDialogues.showDialogue(title: "يتم الآن إرسال الرمز");
                    sendOtp();
                  },
                  child: const PrimaryButton(
                    buttonText: 'إعادة إرسال الرمز',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///======================================================================methods =====================
  //==send otp method
  void sendOtp() async {
    if (widget.email.isNotEmpty) {
      var res =
          await emailAuth.sendOtp(recipientMail: widget.email, otpLength: 6);
      if (res) {
        AllDialogues.hideloading();
        Fluttertoast.showToast(
            msg: "تم إرسال الرمز عبر بريدك الإلكتروني الخاص",
            toastLength: Toast.LENGTH_LONG);
        _startTimer();
      } else {
        setState(() {
          _counter = 00;
        });
        _timer.cancel();
        AllDialogues.hideloading();
        Fluttertoast.showToast(msg: "حدث خطأ");
      }
    } else {
      AllDialogues.hideloading();
      Fluttertoast.showToast(
          msg: "هذا البريد الإلكتروني غير مسجل في تطبيق متزن");
    }
  }

//====verify otp=======
//this function  verify the users email from singup form.
  void verifyEmail() async {
    AllDialogues.showDialogue(title: "يتم الآن التحقق، الرجاء الانتظار...");
    var verified = await emailAuth.validateOtp(
        recipientMail: widget.email, userOtp: otpTextfield.text.toString());
    if (verified) {
      AllDialogues.hideloading();
      //=============after verification of email, we create an account of the user with email and password.
      // =============by calling the method create account with email and password (لازم بعد انشاء الحساب) .

      createAccount(widget.email, widget.pass);
    } else {
      AllDialogues.hideloading();
      Fluttertoast.showToast(
          msg:
              "المعذرة بريدك الإلكتروني غير متحقق \nالرجاء التحقق من بريدك الإلكتروني. ",
          toastLength: Toast.LENGTH_LONG);
    }
  }

//=============create an account in firebase auth.
  void createAccount(email, pass) async {
    AllDialogues.showDialogue(
        title: "يتم الآن إنشاء حسابك في متزن الرجاء الانتظار...");
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: widget.email, password: widget.pass);
      userCredential.user!.updateDisplayName(widget.first_name);
      saveSignUpFormData(widget.first_name, widget.user_name, widget.email,
          widget.pass, userCredential.user!.uid);
      Fluttertoast.showToast(msg: "تم التحقق من بريدك الإلكتروني");
      await FirebaseAuth.instance.signOut();
      AllDialogues.hideloading();
      Get.to(() => const getAllAspects());
    } on FirebaseAuthException catch (e) {
      AllDialogues.hideloading();
      if (e.code == 'weak-password') {
        AllDialogues.showErrorDialog(
            title: "!خطأ",
            discription: "فضلا استخدم كلمة سر قوية مثل: g5D3ep6Hkr5",
            buttonText: "حسنًا");
      } else if (e.code == 'email-already-in-use') {
        AllDialogues.showErrorDialog(
            title: "!خطا", discription: "البريد الإلكتروني مسجل سابقًا");
      } else {
        AllDialogues.showErrorDialog(title: "!خطأ", discription: e.code);
      }
      AllDialogues.showErrorDialog();
    }
  }
}
