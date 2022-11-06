import 'package:get/get.dart';
import 'package:motazen/pages/onboarding_page.dart';
import '/data/data.dart';
import '/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); // initialize the DB
  IsarService iser = IsarService(); // initialize local storage
  iser.openIsar();

  /// check if the the app is in it's first run
  // bool ifr = await IsFirstRun.isFirstRun();

  runApp(ChangeNotifierProvider<WheelData>(
      create: (_) => WheelData(),
      child: const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: MaterialApp(
            debugShowCheckedModeBanner: false,
            home:
                OnboardingPage()), //add verification to check which page should be next (sign in/homepage)
      ))); // my widget // the one where i will create the quastion list .
}
// ifr
//                 ? const OnboardingPage()
//                 : null