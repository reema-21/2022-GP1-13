// import 'package:flutter/material.dart';
// import '/theme.dart';
// import '/pages/reset/new_password_form.dart';
// import '/primary_button.dart';
//
// import '/pages/login/login.dart';
//
// class NewPassword extends StatelessWidget {
//   const NewPassword({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Padding(
//           padding: kDefaultPadding,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(
//                   height: 120,
//                 ),
//                 Text(
//                   'إعادة ضبط كلمة السر',
//                   style: titleText.copyWith(
//                     fontSize: 30,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   '3) قم بإعادة ضبط كلمة السر الجديدة:',
//                   style: subTitle.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const NewPasswordForm(),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const LogInScreen(),
//                       ),
//                     );
//                   },
//                   child: const PrimaryButton(
//                     buttonText: 'التالي',
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 23,
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
