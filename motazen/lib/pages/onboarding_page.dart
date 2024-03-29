import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:motazen/theme.dart';
import '../widget/build_images.dart';
import '/pages/signup/signup.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Container(
        margin: const EdgeInsets.only(top: 100),
        child: IntroductionScreen(
          isBottomSafeArea: true,
          isTopSafeArea: true,
          globalBackgroundColor: kWhiteColor,
          pages: [
            PageViewModel(
              title: 'عجلة الحياة',
              body: 'اصنع عجلة حياتك بالجوانب الي تهمك ',
              image: const BuildImages(
                image: 'assets/images/wheel.png',
              ),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'العادات والمهام',
              body: 'حقق اهدافك و طموحاتك بالالتزام  بمهامك و عاداتك الجيدة ',
              image: const BuildImages(
                image: 'assets/images/todolist.png',
              ),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'الانضمام للمجتمعات',
              body: 'شارك اصدقائك و مجتمعك اهدافك لتشجيع نفسك ',
              image: const BuildImages(
                image: 'assets/images/community.png',
              ),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'لاحظ تقدمك',
              body: 'تابع تقدمك بكل اهدافك و عاداتك',
              image: const BuildImages(
                image: 'assets/images/progress.png',
              ),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: '',
              body: 'هل انت مستعد لبدء رحلتك',
              image: const BuildImages(
                image: 'assets/images/motazen.png',
              ),
              decoration: getPageDecoration(),
              footer: Container(
                margin: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () => goToQuestion(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: kDefaultPadding,
                    backgroundColor: kPrimaryColor,
                    fixedSize: const Size(200, 70),
                    textStyle: textButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: kPrimaryColor)),
                  ),
                  child: const Text(
                    'لنبدأ!',
                  ),
                ),
              ),
            ),
          ],
          next: const Icon(Icons.arrow_forward),
          done: const Text('التالي',
              style: TextStyle(fontWeight: FontWeight.bold)),
          onDone: () => goToHome(context),
          showSkipButton: true,
          skip: const Text('تخطي'),
        ),
      ),
    );
  }

  PageDecoration getPageDecoration() {
    return const PageDecoration(
        titleTextStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        bodyTextStyle: TextStyle(fontSize: 24),
        imagePadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        bodyPadding: EdgeInsets.all(25),
        pageColor: Colors.white,
        safeArea: 10);
  }

  void goToHome(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  void goToQuestion(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }
}
