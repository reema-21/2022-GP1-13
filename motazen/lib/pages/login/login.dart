import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:get/get.dart';
import 'package:motazen/pages/reset/reset_password.dart';
import 'package:motazen/pages/signup/signup.dart';
import 'package:motazen/primary_button.dart';
import 'package:motazen/theme.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroler = TextEditingController();
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'أهلاً بك مجددًا',
                  style: titleText,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      'مستخدم جديد؟',
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
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'إنشاء حساب',
                        style: textButton.copyWith(
                          decoration: TextDecoration.underline,
                          decorationThickness: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                //=================login form=================
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // //=================email field===============
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                              controller: _emailcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'فضلًا ادخل بريدك الإلكتروني';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'البريد الإلكتروني',
                                labelStyle: TextStyle(
                                  color: kTextFieldColor,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: kPrimaryColor),
                                ),
                              ))),

                      //==============password field'======================
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          controller: _passwordcontroler,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'فضلًا ادخل كلمة السر';
                            }
                            return null;
                          },
                          obscureText: obscureText ? true : false,
                          decoration: InputDecoration(
                              labelText: 'كلمة السر',
                              labelStyle: const TextStyle(
                                color: kTextFieldColor,
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                icon: obscureText
                                    ? const Icon(
                                        Icons.visibility_off,
                                        color: kTextFieldColor,
                                      )
                                    : const Icon(
                                        Icons.visibility,
                                        color: kPrimaryColor,
                                      ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'نسيت كلمة المرور؟',
                    style: TextStyle(
                      color: kZambeziColor,
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                      decorationThickness: 1,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //==============Signin Button============================
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      //=============== call a function to sign in with email and pass.
                      //====uncomment the below function when app is connected to firebase.
                      signIn(_emailcontroller.text, _passwordcontroler.text);
                    }
                  },
                  child: const PrimaryButton(
                    buttonText: 'تسجيل الدخول',
                  ),
                ),
                const SizedBox(
                  height: 23,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//=========signin with email and pass method
signIn(email, pass) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass);

    Fluttertoast.showToast(
        msg:
            "تم تسجيل الدخول بنجاح"); //name the second page بعد ما اشيك على الربط

  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      //msg user-not-found
      Fluttertoast.showToast(msg: "لا يوجد مستخدم مسجل عن طريق هذا البريد");
    } else if (e.code == 'wrong-password') {
      Fluttertoast.showToast(msg: "كلمة السر خاطئة، الرجاء التأكد من صحتها");
    } else {
      Fluttertoast.showToast(msg: "حدث خطأ في التسجيل، الرجاء أعد المحاولة");
    }
  }
}
