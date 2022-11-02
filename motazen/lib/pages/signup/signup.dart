import 'package:flutter/material.dart';
import 'package:motazen/isar_service.dart';
import 'package:provider/provider.dart';
import '../../data/data.dart';
import '../select_aspectPage/select_aspect.dart';
import '/pages/login/login.dart';
import '/theme.dart';
import '/primary_button.dart';
import '/pages/signup/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isar = IsarService();
    var aspectList = Provider.of<WheelData>(context);

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70,
              ),
              Padding(
                padding: kDefaultPadding,
                child: Text(
                  'إنشاء حساب',
                  style: titleText,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: kDefaultPadding,
                child: Row(
                  children: [
                    Text(
                      'لديك حساب سابق؟',
                      style: subTitle,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LogInScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'سجّل دخولك',
                        style: textButton.copyWith(
                          decoration: TextDecoration.underline,
                          decorationThickness: 1,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: kDefaultPadding,
                child: SignUpForm(),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: kDefaultPadding,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AspectSelection(
                          isr: isar,
                          aspects: aspectList.aspectsArabic,
                        ),
                      ),
                    );
                  },
                  child: const PrimaryButton(
                    buttonText: 'التالي',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
