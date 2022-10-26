import 'package:flutter/material.dart';
import '/theme.dart';
import '/primary_button.dart';
import '/pages/reset/reset_form.dart';
import 'verify.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 120,
              ),
              Text(
                'إعادة تعيين كلمة السر',
                style: titleText.copyWith(
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '1) من فضلك، قم بادخال بريدك الإلكتروني:',
                style: subTitle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const ResetForm(),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerifyScreen(),
                    ),
                  );
                },
                child: const PrimaryButton(
                  buttonText: 'التالي',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
