import 'package:flutter/material.dart';
import 'package:motazen/pages/reset/reset_form.dart';
import 'package:motazen/theme.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor.withOpacity(0),
        iconTheme: const IconThemeData(
          color: kBlackColor,
        ),
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: kDefaultPadding,
          child: SingleChildScrollView(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
