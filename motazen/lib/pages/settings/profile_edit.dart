import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motazen/pages/reset/reset_password.dart';
import 'package:motazen/pages/settings/setting_screen.dart';
import 'package:motazen/primary_button.dart';
import 'package:motazen/theme.dart';

import '../../controllers/auth_controller.dart';
import '../../dialogue_boxes.dart';
import '../select_aspectPage/handle_aspect_data.dart';

final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showOldPassword = true;
  bool showNewPassword = true;
  bool showConfirmNewPassword = true;
  final emailController = TextEditingController();
  final firstnameController = TextEditingController();
  final usernameController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  final _firstNameKey = GlobalKey<FormState>();
  final _userNameKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _oldPassKey = GlobalKey<FormState>();
  final _newPassKey = GlobalKey<FormState>();
  final _confirmNewPassKey = GlobalKey<FormState>();
  String oldFirstName = "";
  String oldUsername = "";
  String oldEmail = "";

  CollectionReference ref = FirebaseFirestore.instance.collection('user');
  final userID = FirebaseAuth.instance.currentUser;
  AuthController authController = Get.find(); // for the avatar url
  final ImagePicker _picker = ImagePicker();
  String cuurentProfile = "";
  Future<void> getImage() async {
    XFile? profileImage = await _picker.pickImage(source: ImageSource.gallery);
    File file = File(profileImage!.path);

    final user = FirebaseAuth.instance.currentUser;
    final storageRef =
        FirebaseStorage.instance.ref().child("user/profile/${user!.uid}.jpg");
    var uploadTask = await storageRef.putFile(file);
    String profileImageUrl = await uploadTask.ref.getDownloadURL();
    setState(() {
      //get the llink and save to firebase and the current.avtarURL value
      authController.setUserAvatar(profileImageUrl);
      authController.currentUser.value.avatarURL = profileImageUrl;
    });
  }

  @override
  void initState() {
    if (authController.currentUser.value.avatarURL != null) {
      cuurentProfile = authController.currentUser.value.avatarURL!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    oldEmail = '${FirebaseAuth.instance.currentUser!.email}';
    if (emailController.text.isEmpty) {
      emailController.text = oldEmail;
    }
    oldUsername = '${FirebaseAuth.instance.currentUser!.displayName}';
    if (firstnameController.text.isEmpty) {
      firstnameController.text = oldUsername;
    }
    final docRef =
        firestore.collection('user').doc(firebaseAuth.currentUser!.uid);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        oldFirstName = data['userName'] ?? "";
        if (usernameController.text.isEmpty) {
          usernameController.text = oldFirstName;
        }
      },
      onError: (e) => log("Error getting document: $e"),
    );
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
            if (!(usernameController.text != oldFirstName ||
                firstnameController.text != oldUsername ||
                emailController.text != oldEmail ||
                oldPasswordController.text.isNotEmpty ||
                cuurentProfile != authController.currentUser.value.avatarURL)) {
              Navigator.pop(context);
            } else {
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
                                setState(() {
                                  if (cuurentProfile == "") {
                                    authController.setUserAvatar("");
                                    authController.currentUser.value.avatarURL =
                                        "";
                                  } else {
                                    authController
                                        .setUserAvatar(cuurentProfile);
                                    authController.currentUser.value.avatarURL =
                                        cuurentProfile;
                                  }
                                  //get the llink and save to firebase and the current.avtarURL value
                                });
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
                    Obx(
                      () => Container(
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
                        ),
                        child: CircleAvatar(
                            backgroundImage: authController
                                            .currentUser.value.avatarURL ==
                                        null ||
                                    authController
                                            .currentUser.value.avatarURL ==
                                        ""
                                ? null
                                : CachedNetworkImageProvider(
                                    authController.currentUser.value.avatarURL!,
                                    errorListener: () {}),
                            radius: 32,
                            backgroundColor: kWhiteColor,
                            child: authController.currentUser.value.avatarURL ==
                                    null
                                ? const Icon(
                                    Icons
                                        .account_circle_sharp, //? is better to have the same icon as the one in the side bar
                                    color: Color.fromARGB(31, 97, 96, 96),
                                    size: 120,
                                  )
                                : null),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                            onTap: () async {
                              // open the gallery
                              getImage();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.green,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ))),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
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
                        labelText: "تعديل اسم المستخدم",
                        labelStyle: TextStyle(
                          color: kTextFieldColor,
                        ),
                      ),
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
                          return "لا يمكن أن يحتوي على أكثر من 7 أرقام";
                        }
                        if (!RegExp(r"^[A-Za-z0-9]*$").hasMatch(value)) {
                          return "يقبل الحروف والأعداد الإنجليزية دون الرموز.";
                        }

                        return null;
                      }),
                ),
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
                      labelText: "تعديل الاسم الأول",
                      labelStyle: TextStyle(
                        color: kTextFieldColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      }
                      if (!RegExp(r"^[\u0600-\u06FF ]+").hasMatch(value)) {
                        return "اسمك الأول باللغة العربية"; //
                      }
                      return null;
                    },
                  ),
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
                        labelText: "تعديل البريد الإلكتروني",
                        labelStyle: TextStyle(
                          color: kTextFieldColor,
                        )),
                  ),
                ),
              ),
              ////////////////////////////////////////////////////////
              Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: Form(
                    key: _oldPassKey,
                    child: TextFormField(
                      obscureText: showOldPassword,
                      controller: oldPasswordController,
                      validator: (value) {
                        return "كلمة السر لا تتطابق";
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showOldPassword = !showOldPassword;
                            });
                          },
                          icon: showOldPassword
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: kTextFieldColor,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: kPrimaryColor,
                                ),
                        ),
                        contentPadding: const EdgeInsets.only(bottom: 3),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "كلمة السر الحالية",
                        labelStyle: const TextStyle(
                          color: kTextFieldColor,
                        ),
                      ),
                    ),
                  )),
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
                  'نسيت كلمة السر الحالية؟',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 17,
                    decoration: TextDecoration.underline,
                    decorationThickness: 1,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ////////////////////////////////////
              Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: Form(
                    key: _newPassKey,
                    child: TextFormField(
                      obscureText: showNewPassword,
                      controller: newPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        if (value.length < 6) {
                          return 'كلمة السر يجب أن تكون 6 خانات فأكثر ';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showNewPassword = !showNewPassword;
                            });
                          },
                          icon: showNewPassword
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: kTextFieldColor,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: kPrimaryColor,
                                ),
                        ),
                        contentPadding: const EdgeInsets.only(bottom: 3),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "تعديل كلمة السر",
                        labelStyle: const TextStyle(
                          color: kTextFieldColor,
                        ),
                      ),
                    ),
                  )),

              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Form(
                  key: _confirmNewPassKey,
                  child: TextFormField(
                    controller: confirmNewPasswordController,
                    obscureText: showConfirmNewPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        if (newPasswordController.text ==
                            confirmNewPasswordController.text) return null;
                        return 'فضلًا ادخل كلمة السر';
                      }
                      if (newPasswordController.text !=
                          confirmNewPasswordController.text) {
                        return "الكلمة لا تتطابق";
                      }

                      if (value.length < 6) {
                        return 'كلمة السر يجب أن تكون 6 خانات فأكثر ';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showConfirmNewPassword = !showConfirmNewPassword;
                          });
                        },
                        icon: showConfirmNewPassword
                            ? const Icon(
                                Icons.visibility_off,
                                color: kTextFieldColor,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: kPrimaryColor,
                              ),
                      ),
                      contentPadding: const EdgeInsets.only(bottom: 3),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "تأكيد كلمة السر الجديدة",
                      labelStyle: const TextStyle(
                        color: kTextFieldColor,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  bool formIsOkay = true;
                  if (!(usernameController.text.isNotEmpty ||
                      firstnameController.text.isNotEmpty ||
                      emailController.text.isNotEmpty ||
                      newPasswordController.text.isNotEmpty)) {
                    Fluttertoast.showToast(msg: "الرجاء ادخل بياناتك لتغييرها");
                  }
                  if (usernameController.text.isNotEmpty &&
                      usernameController.text != oldFirstName) {
                    if (!_userNameKey.currentState!.validate()) {
                      setState(() {
                        formIsOkay = false;
                      });
                    }
                  }
                  if (firstnameController.text.isNotEmpty &&
                      firstnameController.text != oldUsername) {
                    if (!_firstNameKey.currentState!.validate()) {
                      setState(() {
                        formIsOkay = false;
                      });
                      final validUserName = await usernameCheck(
                          firstnameController.text.toLowerCase());
                      if (!validUserName) {
                        setState(() {
                          formIsOkay = false;
                        });
                        AllDialogues.showErrorDialog(
                            title: "!هذا المستخدم مسجل سابقًا",
                            discription:
                                " مسجل سابقًا، سجّل باسم مستخدم جديد ${firstnameController.text} ");
                      }
                    }
                  }
                  //firstName
                  if (formIsOkay &&
                      usernameController.text.isNotEmpty &&
                      usernameController.text != oldFirstName &&
                      _userNameKey.currentState!.validate()) {
                    ref.doc(userID!.uid.toString()).update({
                      'userName': usernameController.text.toString(),
                    }).then((value) {
                      Fluttertoast.showToast(msg: "تم بنجاح");
                      usernameController.text = '';

                      setState(() {});
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const GetAllAspects(
                                    page: 'Home',
                                  )));
                    }).onError((error, stackTrace) {});
                  }
                  // username
                  if (formIsOkay &&
                      firstnameController.text.isNotEmpty &&
                      firstnameController.text != oldUsername &&
                      _firstNameKey.currentState!.validate()) {
                    final validUserName = await usernameCheck(
                        firstnameController.text.toLowerCase());
                    if (!validUserName) {
                      AllDialogues.showErrorDialog(
                          title: "!هذا المستخدم مسجل سابقًا",
                          discription:
                              " مسجل سابقًا، سجّل باسم مستخدم جديد ${firstnameController.text} ");
                    } else {
                      userID!
                          .updateDisplayName(
                              firstnameController.text.toString())
                          .then((value) {});
                      ref.doc(userID!.uid.toString()).update({
                        'firstName':
                            firstnameController.text.toString().toLowerCase(),
                      }).then((value) {
                        Fluttertoast.showToast(msg: "تم بنجاح");
                        firstnameController.text = '';
                        setState(() {});
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const GetAllAspects(
                                      page: 'Home',
                                    )));
                      }).onError((error, stackTrace) {});
                    }
                  }

                  //email
                  if (formIsOkay &&
                      emailController.text.isNotEmpty &&
                      emailController.text != oldEmail &&
                      _emailKey.currentState!.validate()) {
                    if (oldPasswordController.text.isNotEmpty) {
                      final cred = EmailAuthProvider.credential(
                          email: oldEmail,
                          password: oldPasswordController.text);
                      firebaseAuth.currentUser!
                          .reauthenticateWithCredential(cred)
                          .then((value) async {
                        final validEmail = await emailIdCheck(
                            emailController.text.toLowerCase());
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
                                          const GetAllAspects(
                                            page: 'Home',
                                          )));
                            }).onError((error, stackTrace) {});
                          });
                        }
                      }).onError((error, stackTrace) {
                        _oldPassKey.currentState!.validate();
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: "لتغيير البريد الإلكتروني، ادخل كلمة المرور");
                    }
                  }
                  // password
                  if (formIsOkay &&
                      newPasswordController.text.isNotEmpty &&
                      _newPassKey.currentState!.validate() &&
                      _confirmNewPassKey.currentState!.validate()) {
                    /////////////////////////////
                    if (oldPasswordController.text.isNotEmpty) {
                      final cred = EmailAuthProvider.credential(
                          email: oldEmail,
                          password: oldPasswordController.text);
                      firebaseAuth.currentUser!
                          .reauthenticateWithCredential(cred)
                          .then((value) async {
                        userID!
                            .updatePassword(newPasswordController.text)
                            .then((value) {
                          Fluttertoast.showToast(msg: "تم بنجاح");
                          newPasswordController.text = '';
                          confirmNewPasswordController.text = '';
                          setState(() {});
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const GetAllAspects(
                                        page: 'Home',
                                      )));
                        }).onError((error, stackTrace) {});
                      }).onError((error, stackTrace) {
                        _oldPassKey.currentState!.validate();
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: "لتغيير كلمة السر ادخل كلمة السر الحالية");
                    }
                    ////////
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
