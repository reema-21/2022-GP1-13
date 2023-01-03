import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/login/login.dart';
import 'package:motazen/pages/onboarding_page.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import '/data/data.dart';
import 'firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); // initialize the DB
  IsarService iser = IsarService(); // initialize local storage
  iser.openIsar();

  /// check if the the app is in it's first run
  bool ifr = await IsFirstRun.isFirstRun();
  iser = IsarService();
  runApp(ChangeNotifierProvider<WheelData>(
      create: (_) => WheelData(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            backgroundColor: kWhiteColor,
            fontFamily: 'Frutiger',
            appBarTheme: AppBarTheme(
              backgroundColor: kWhiteColor,
              iconTheme: const IconThemeData(color: kBlackColor),
              titleTextStyle: titleText,
              toolbarTextStyle: subTitle,
              elevation: 0,
            ),
            primaryColor: kPrimaryColor,
            buttonTheme: const ButtonThemeData(disabledColor: kDisabled)),
        home: ifr
            ? const OnboardingPage()
            : const LogInScreen(), //add verification to check which page should be next (sign in/homepage)
        locale: const Locale('ar', ''),

        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      )));
}
