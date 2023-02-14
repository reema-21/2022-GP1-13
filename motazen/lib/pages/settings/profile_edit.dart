import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motazen/pages/settings/setting_screen.dart';
import 'package:motazen/primary_button.dart';

import '../../dialogue_boxes.dart';
import '../select_aspectPage/handle_aspect_data.dart';

final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

class SettingsUI extends StatelessWidget {
  const SettingsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //Note: why use the material app widget again (a new tree is created)
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = true;
  bool showConfirmPassword = true;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final firstnameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _userNameKey = GlobalKey<FormState>();
  final _firstNameKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormState>();
  final _confirmPassKey = GlobalKey<FormState>();

  CollectionReference ref = FirebaseFirestore.instance.collection('user');
  final userID = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        title: const Text(
          "تعديل الملف ",
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          onPressed: () {
            if (!(firstnameController.text.isNotEmpty ||
                usernameController.text.isNotEmpty ||
                emailController.text.isNotEmpty ||
                passwordController.text.isNotEmpty))
              Navigator.pop(context);
            else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('تنبيه!'),
                      content: const SizedBox(
                        child: Text(
                            ' في حال مغادرتك الصفحة، لن تُحفظ التعديلات التي أجريتها'),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('مغادرة'),
                            ),
                          ],
                        ),
                      ],
                    );
                  });
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const SettingScreen()));
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                "",
                              ))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.green,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Form(
                  key: _firstNameKey,
                  child: TextFormField(
                    controller: firstnameController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "تعديل الاسم الأول",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      }
                      if (!RegExp(r"^[\u0600-\u06FF ]+").hasMatch(value)) {
                        return "ادخلك اسمك باللغة العربية"; //
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Form(
                  key: _userNameKey,
                  child: TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "تعديل اسم المستخدم",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        if (value.length > 16 || value.length < 4) {
                          return "اسم المستخدم يجب أن يكون بين 4-16 خانة";
                        }
                        int nums = 0;
                        for (int i = 0; i < value.length; i++) {
                          if (value[i] == '0' ||
                              value[i] == '1' ||
                              value[i] == '2' ||
                              value[i] == '3' ||
                              value[i] == '4' ||
                              value[i] == '5' ||
                              value[i] == '6' ||
                              value[i] == '7' ||
                              value[i] == '8' ||
                              value[i] == '9') {
                            nums += 1;
                          }
                        }
                        if (nums > 7) {
                          return "اسم المستخدم لا يمكن أن يحتوي على أكثر من 7 أرقام";
                        }
                        if (!RegExp(r"^[A-Za-z0-9]*$").hasMatch(value)) {
                          return "اسم المستخدم يقبل الحروف والأعداد الإنجليزية دون الرموز.";
                        }

                        return null;
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Form(
                  key: _emailKey,
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'فضلًا ادخل بريدك الإلكتروني';
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z]+\.com+")
                          .hasMatch(value)) {
                        return "البريد الإلكتروني غير صحيح";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "تعديل البريد الإلكتروني",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        )),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: Form(
                    key: _passKey,
                    child: TextFormField(
                      obscureText: showPassword,
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        if (value.length < 6) {
                          return 'كلمة السر يجب أن تكون 6 خانات فأكثر مثل:IH2D45f';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(bottom: 3),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "تعديل كلمة السر",
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          )),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Form(
                  key: _confirmPassKey,
                  child: TextFormField(
                    controller: confirmPasswordController,
                    obscureText: showConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        if (passwordController.text ==
                            confirmPasswordController.text) return null;
                        return 'فضلًا ادخل كلمة السر';
                      }
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        return "الكلمة لا تتطابق";
                      }

                      if (value.length < 6) {
                        return 'كلمة السر يجب أن تكون 6 خانات فأكثر مثل:IH2D45f';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showConfirmPassword = !showConfirmPassword;
                            });
                          },
                          icon: const Icon(
                            Icons.remove_red_eye,
                            color: Colors.grey,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(bottom: 3),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "تأكيد كلمة السر الجديدة",
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        )),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (!(firstnameController.text.isNotEmpty ||
                      usernameController.text.isNotEmpty ||
                      emailController.text.isNotEmpty ||
                      passwordController.text.isNotEmpty)) {
                    Fluttertoast.showToast(msg: "الرجاء ادخل بياناتك لتغييرها");
                  }
                  //firstName
                  if (firstnameController.text.isNotEmpty &&
                      _firstNameKey.currentState!.validate()) {
                    userID!
                        .updateDisplayName(firstnameController.text.toString())
                        .then((value) {});
                    ref.doc(userID!.uid.toString()).update({
                      'firstName': firstnameController.text.toString(),
                    }).then((value) {
                      Fluttertoast.showToast(msg: "تم بنجاح");
                      firstnameController.text = '';

                      setState(() {});
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const getAllAspects(
                                    page: 'Home',
                                  )));
                    }).onError((error, stackTrace) {});
                  }
                  // username
                  if (usernameController.text.isNotEmpty &&
                      _userNameKey.currentState!.validate()) {
                    final validUserName = await usernameCheck(
                        usernameController.text.toLowerCase());
                    if (!validUserName) {
                      AllDialogues.showErrorDialog(
                          title: "!هذا المستخدم مسجل سابقًا",
                          discription:
                              " مسجل سابقًا، سجّل باسم مستخدم جديد ${usernameController.text} ");
                    } else {
                      ref.doc(userID!.uid.toString()).update({
                        'userName':
                            usernameController.text.toString().toLowerCase(),
                      }).then((value) {
                        Fluttertoast.showToast(msg: "تم بنجاح");
                        usernameController.text = '';
                        setState(() {});
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const getAllAspects(
                                      page: 'Home',
                                    )));
                      }).onError((error, stackTrace) {});
                    }
                  }

                  //email
                  if (emailController.text.isNotEmpty &&
                      _emailKey.currentState!.validate()) {
                    final validEmail =
                        await emailIdCheck(emailController.text.toLowerCase());
                    AllDialogues.hideloading();
                    if (!validEmail) {
                      AllDialogues.showErrorDialog(
                          title: "!البريد الإلكتروني موجود مُسبقًا",
                          discription:
                              " مسجل مسبقًا, الرجاء التسجيل ببريد آخر ${emailController.text} البريد الإلكتروني  ");
                    } else {
                      userID!
                          .updateEmail(emailController.text.toString())
                          .then((value) {
                        ref.doc(userID!.uid.toString()).update({
                          'email': emailController.text.toString(),
                        }).then((value) {
                          Fluttertoast.showToast(msg: "تم بنجاح");
                          emailController.text = '';
                          setState(() {});
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const getAllAspects(
                                        page: 'Home',
                                      )));
                        }).onError((error, stackTrace) {});
                      });
                    }
                  }
                  // password
                  if (passwordController.text.isNotEmpty &&
                      _passKey.currentState!.validate() &&
                      _confirmPassKey.currentState!.validate()) {
                    userID!
                        .updatePassword(passwordController.text)
                        .then((value) {
                      Fluttertoast.showToast(msg: "تم بنجاح");
                      passwordController.text = '';
                      confirmPasswordController.text = '';
                      setState(() {});
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const getAllAspects(
                                    page: 'Home',
                                  )));
                    }).onError((error, stackTrace) {});
                  }
                },
                child: const PrimaryButton(buttonText: 'أحفظ التغييرات'),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> usernameCheck(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('user')
        .where('userName', isEqualTo: username)
        .get();
    return result.docs.isEmpty;
  }

  Future<bool> emailIdCheck(String email) async {
    final result = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isEmpty;
  }
}
