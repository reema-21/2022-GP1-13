import 'package:get/get.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:motazen/pages/onboarding_page.dart';
import '/data/data.dart';
import '/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/login/login.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); // initialize the DB
  IsarService iser = IsarService(); // initialize local storage
  iser.openIsar();

  /// check if the the app is in it's first run
  bool ifr = await IsFirstRun.isFirstRun();

  runApp(ChangeNotifierProvider<WheelData>(
      create: (_) => WheelData(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ifr
                ? const OnboardingPage()
                : const LogInScreen()), //add verification to check which page should be next (sign in/homepage)
      )));
}
