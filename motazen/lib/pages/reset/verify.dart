import 'package:flutter/material.dart';
import '/theme.dart';
import '/primary_button.dart';
import '/pages/reset/verify_form.dart';

import 'new_password.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

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
                'التحقق من بريدك الإلكتروني',
                style: titleText.copyWith(
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '2) ادخل الرمز المرسل عبر بريدك:',
                style: subTitle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const VerifyForm(),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewPassword(),
                    ),
                  );
                },
                child: const PrimaryButton(
                  buttonText: 'تأكيد',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
