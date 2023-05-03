// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:motazen/create_otp.dart';
import 'package:motazen/dialogue_boxes.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/pages/signup/sign_up_method.dart';
import 'package:motazen/primary_button.dart';
import 'package:motazen/theme.dart';
import '../select_aspectPage/handle_aspect_data.dart';

class VerifyScreen extends StatefulWidget {
  //======= this data is received from sign up form.
  final String firstName;
  final String userName;
  String email;
  final String pass;
  VerifyScreen(
      {Key? key,
      required this.firstName,
      this.userName = "",
      this.email = "",
      this.pass = ""})
      : super(key: key);
  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _otpformkey = GlobalKey<FormState>(
      debugLabel: 'myOtpFormKey-${UniqueKey().toString()}');
  TextEditingController otpTextfield = TextEditingController();

  //=====================timer
  int _counter = 60;
  String sentOTP = '';
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
    sentOTP = generateOTP();
    sendOTP(widget.email, sentOTP);
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
                key: _otpformkey,
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
                  if (_otpformkey.currentState!.validate()) {
                    verifyEmail();
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
                onTap: () async {
                  AllDialogues.showDialogue(title: "يتم الآن إرسال الرمز");
                  sentOTP = generateOTP();
                  await sendOTP(widget.email, sentOTP);
                  AllDialogues.hideloading();
                },
                child: const PrimaryButton(
                  buttonText: 'إعادة إرسال الرمز',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///======================================================================methods =====================
  //==send otp method

  sendOTP(String receiverEmail, String otp) async {
    String username = 'motazenapp@gmail.com';
    String password = "nwzwtraabozrdipz";

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Motazen')
      ..recipients.add(receiverEmail)
      ..subject = ' مُتزن- تأكيد هوية المستخدم من خلال رمز التحقق لمرة واحدة  '
      ..text =
          ' .  إذا لم تقم بطلب رمز التحقق فضلا تجاهل هذه الرسالة. \n\n فريق مُتزن $otp رمز التحقق من هويتك من خلال البريد المُسجل لدينا في تطبيق متزن هو   $receiverEmailعزيزي ';

    try {
      await send(message, smtpServer);
      AllDialogues.hideloading();
      Fluttertoast.showToast(
          msg: "تم إرسال الرمز عبر بريدك الإلكتروني الخاص",
          toastLength: Toast.LENGTH_LONG);
      _startTimer();
    } on MailerException catch (e) {
      setState(() {
        _counter = 00;
      });
      _timer.cancel();
      AllDialogues.hideloading();
      Fluttertoast.showToast(msg: "حدث خطأ");
      log('error on verify page: $e');
    }
  }

  sendInvitation(String receiverEmail, Community comm) async {
    String username = 'motazenapp@gmail.com';
    String password = "nwzwtraabozrdipz";

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Motazen')
      ..recipients.add(receiverEmail)
      ..subject = 'Motazen Community Invitation [${comm.communityName}]'
      ..text =
          'Dear $receiverEmail,\n${comm.founderUsername} has invited you in the community ${comm.communityName}. Please check the app notification to accept or reject the invitation\n\nRegards,\nTeam Motazen';

    try {
      await send(message, smtpServer);
      AllDialogues.hideloading();
      Fluttertoast.showToast(
          msg: "Invite sent", toastLength: Toast.LENGTH_LONG);
      _startTimer();
    } on MailerException catch (e) {
      setState(() {
        _counter = 00;
      });
      _timer.cancel();
      AllDialogues.hideloading();
      Fluttertoast.showToast(msg: "Failed sending invite mail");
      log('error on verify: $e');
    }
  }

//====verify otp=======
//this function  verify the users email from singup form.
  void verifyEmail() async {
    AllDialogues.showDialogue(title: "يتم الآن التحقق، الرجاء الانتظار...");
    var verified = otpTextfield.text.toString() == sentOTP;
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
      await userCredential.user!.updateDisplayName(widget.firstName);
      await saveSignUpFormData(widget.firstName, widget.userName, widget.email,
          widget.pass, userCredential.user!.uid);
      Fluttertoast.showToast(msg: "تم التحقق من بريدك الإلكتروني");
      AllDialogues.hideloading();
      Get.to(() => const InitializeAspects());
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
