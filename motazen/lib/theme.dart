import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const kPrimaryColor = Color(0xFF66BF77);
const kSecondaryColor = Color(0xFF595E70);
const kDarkGreyColor = Color(0xFFA8A8A8);
const kWhiteColor = Color(0xFFFFFFFF);
const kZambeziColor = Color(0xFF5B5B5B);
const kBlackColor = Color(0xFF272726);
const kTextFieldColor = Color(0xFF979797);
const kDisabled = Color(0xffE2E2E2);
const kAlertColor = Color(0xff009fe3);

const kDefaultPadding = EdgeInsets.symmetric(horizontal: 30);
const kButtonMargin = EdgeInsets.all(30.0);

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firestore = FirebaseFirestore.instance;

TextStyle titleText = const TextStyle(
    color: kPrimaryColor,
    fontSize: 32,
    fontFamily: 'Frutiger',
    fontWeight: FontWeight.w700);
TextStyle titleText2 = const TextStyle(
    color: kPrimaryColor,
    fontSize: 18,
    fontFamily: 'Frutiger',
    fontWeight: FontWeight.w700);
TextStyle subTitle = const TextStyle(
    color: kSecondaryColor,
    fontSize: 18,
    fontFamily: 'Frutiger',
    fontWeight: FontWeight.w500);
TextStyle textButton = const TextStyle(
    color: kPrimaryColor,
    fontSize: 18,
    fontFamily: 'Frutiger',
    fontWeight: FontWeight.w700);

TextStyle titleText3 = const TextStyle(
  color: kPrimaryColor,
  fontSize: 18,
  fontFamily: 'Frutiger',
  fontWeight: FontWeight.w700,
);

TextStyle textButton2 = const TextStyle(
  color: kWhiteColor,
  fontSize: 16,
  fontFamily: 'Frutiger',
  fontWeight: FontWeight.w700,
);
TextStyle alertText = const TextStyle(
    color: kAlertColor, fontSize: 16, fontWeight: FontWeight.w500);

TextStyle sidebarUser = const TextStyle(
  color: kWhiteColor,
  fontSize: 18,
  fontFamily: 'Frutiger',
);
TextStyle normalText = const TextStyle(
  color: kBlackColor,
  fontSize: 25,
  fontFamily: 'Frutiger',
  fontWeight: FontWeight.w700,
);

getErrorSnackBar(String message) {
  Get.snackbar(
    'خطأ',
    message,
    titleText: txt(
        txt: 'خطأ',
        fontSize: 22,
        fontColor: Colors.white,
        fontWeight: FontWeight.bold),
    messageText: txt(txt: message, fontSize: 14, fontColor: Colors.white),
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.red.shade300,
    borderRadius: 0,
    margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
  );
}

getWarningSnackBar(String message) {
  Get.snackbar(
    'Warning',
    message,
    titleText: txt(
        txt: 'Warning',
        fontSize: 22,
        fontColor: Colors.black54,
        fontWeight: FontWeight.bold),
    messageText: txt(txt: message, fontSize: 14, fontColor: Colors.black54),
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.yellow.shade300,
    borderRadius: 0,
    margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
  );
}

getSuccessSnackBar(String message) {
  Get.snackbar(
    'نجح',
    message,
    titleText: txt(
        txt: 'نجح',
        fontSize: 22,
        fontColor: Colors.white,
        fontWeight: FontWeight.bold),
    messageText: txt(txt: message, fontSize: 14, fontColor: Colors.white),
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.green.shade300,
    borderRadius: 0,
    margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
  );
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

//for all the text in the app
Widget txt(
    {required String txt,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    required double fontSize,
    Color? fontColor,
    double? minFontSize,
    double? letterSpacing,
    TextOverflow? overflow,
    TextAlign? textAlign,
    bool? isUnderline,
    String? font,
    int? maxLines}) {
  return AutoSizeText(
    txt,
    maxLines: maxLines ?? 1,
    maxFontSize: fontSize,
    minFontSize: minFontSize ?? fontSize - 10,
    textAlign: textAlign,
    style: TextStyle(
      decoration:
          isUnderline == null ? TextDecoration.none : TextDecoration.underline,
      fontStyle: fontStyle ?? FontStyle.normal,
      overflow: overflow ?? TextOverflow.ellipsis,
      letterSpacing: letterSpacing ?? 0,
      color: fontColor,
      fontWeight: fontWeight ?? FontWeight.normal,
    ),
  );
}
