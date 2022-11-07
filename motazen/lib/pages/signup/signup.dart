import 'package:flutter/material.dart';
import 'package:motazen/pages/login/login.dart';
import 'package:motazen/pages/signup/signup_form.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';

import '../../data/data.dart';
import '../select_aspectPage/handle_aspect_data.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              //=========form starts here
              const Padding(
                padding: kDefaultPadding,
                child: SignUpForm(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
