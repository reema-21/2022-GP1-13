import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

const kPrimaryColor = Color(0xFF66BF77);
const kSecondaryColor = Color(0xFF595E70);
const kDarkGreyColor = Color(0xFFA8A8A8);
const kWhiteColor = Color(0xFFFFFFFF);
const kZambeziColor = Color(0xFF5B5B5B);
const kBlackColor = Color(0xFF272726);
const kTextFieldColor = Color(0xFF979797);
const kDisabled = Color(0xffE2E2E2);

const kDefaultPadding = EdgeInsets.symmetric(horizontal: 30);
const kButtonMargin = EdgeInsets.all(30.0);

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
TextStyle subTitleBold = const TextStyle(
    color: kSecondaryColor,
    fontSize: 14,
    fontFamily: 'Frutiger',
    fontWeight: FontWeight.bold);
TextStyle textButton = const TextStyle(
  color: kPrimaryColor,
  fontSize: 18,
  fontFamily: 'Frutiger',
  fontWeight: FontWeight.w700,
);

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

/// Convenience class to access application colors.
abstract class AppColors {
  /// Dark background color.
  static const Color backgroundColor = Color(0xFF191D1F);

  /// Slightly lighter version of [backgroundColor].
  static const Color backgroundFadedColor = Color(0xFF191B1C);

  /// Color used for cards and surfaces.
  static const Color cardColor = Color(0xFF1F2426);

  /// Accent color used in the application.
  static const Color accentColor = Color(0xFFef8354);
}
