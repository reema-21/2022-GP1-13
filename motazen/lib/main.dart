import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:motazen/controllers/item_list_controller.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/login/login.dart';
import 'package:motazen/pages/onboarding_page.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import 'controllers/aspect_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Delay the initialization of IsarService to a background thread
  Timer.run(() async {
    IsarService iser = IsarService();
    await iser.openIsar();

    // Check if the app is in its first run
    bool isFirstRun = await IsFirstRun.isFirstRun();

    // Initialize Firebase
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    // Remove the splash screen
    FlutterNativeSplash.remove();
    // Run the app
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AspectController>(
              create: (_) => AspectController()),
          ChangeNotifierProvider<ItemListProvider>(
              create: (_) => ItemListProvider()),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            colorScheme: const ColorScheme.light(primary: kPrimaryColor),
            fontFamily: 'Frutiger',
            appBarTheme: AppBarTheme(
              backgroundColor: kWhiteColor,
              iconTheme: const IconThemeData(color: kBlackColor),
              titleTextStyle: titleText,
              toolbarTextStyle: subTitle,
              elevation: 0,
            ),
            buttonTheme: const ButtonThemeData(disabledColor: kDisabled),
          ),
          home: isFirstRun ? const OnboardingPage() : const LogInScreen(),
          locale: const Locale('ar', ''),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  });
}
