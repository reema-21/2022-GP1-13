import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'widget/build_images.dart';
import 'homePag.dart';
// import 'widget/select_aspect.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(pages: [
        PageViewModel(
          title: 'Wheel',
          body: 'اهلا هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي ',
          image: const BuildImages(image: 'assets/images/wheel.png',),
          decoration: getPageDecoration(),

        ),

        PageViewModel(
          title: 'List',
          body: 'اهلا هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي ',
          image: const BuildImages(image: 'assets/images/todolist.png',),
          decoration: getPageDecoration(),
        ),


        PageViewModel(
          title: 'Community',
          body: 'اهلا هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي ',
          image: const BuildImages(image: 'assets/images/community.png',),
          decoration: getPageDecoration(),
        ),

        PageViewModel(
          title: 'Progress',
          body: 'اهلا هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي هنا بنحط كلام عن هذا الشي ',
          image: const BuildImages(image: 'assets/images/progress.png',),
          decoration: getPageDecoration(),
        ),


        PageViewModel(
          title: 'Motazen',
          body: 'هنا بنحط الي ارسلته منار اول عن الباي',
          image: const BuildImages(image: 'assets/images/motazen.png',),
          decoration: getPageDecoration(),
          footer: ElevatedButton(
            onPressed: () => goToQuestion(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, padding: const EdgeInsets.all(20.0), backgroundColor: const Color.fromARGB(255, 66, 131, 196),
                fixedSize: const Size(200,70),
                textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
               // elevation: 15,
               // shadowColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),
      side: const BorderSide(color: Color.fromARGB(255, 66, 131, 196))),
              ),
              child: const Text('!لنبدأ'),
              ),

        ),


      ],
      next: const Icon(Icons.arrow_forward),
      done: const Text('التالي', style: TextStyle(fontWeight: FontWeight.bold)),
      onDone: () => goToHome(context),
      showSkipButton: true,
      skip: const Text('تخطي'),
      //animationDuration: 350,
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
    );
  }
  void goToHome(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const homePag()), //this is where you add manars part
      //you will name her page instead of HomePage and import it as a package :)
    );
  }

  void goToQuestion(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  const homePag()), //this is where you add manars part
      //you will name her page instead of HomePage and import it as a package :)
      //btw ترا ذا مب المفروض يودي للهوم بيج بس بعدله - ريم
    );
  }

}
