import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/pages/login/login.dart';
import 'package:motazen/pages/settings/setting_screen.dart';
import 'package:motazen/theme.dart';

import '../pages/assesment_page/alert_dialog.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final userID = FirebaseAuth.instance.currentUser;

  final emailController = TextEditingController();
  final usernameController = TextEditingController();

  /// for update data
  CollectionReference ref = FirebaseFirestore.instance.collection('user');

  final userName = FirebaseAuth.instance.currentUser!.displayName;
  final userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    /// see documentation

    double width = MediaQuery.of(context).size.width;
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: width,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            decoration: const BoxDecoration(
              color: kPrimaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: kWhiteColor,
                  child: Icon(
                    Icons.person,
                    color: kBlackColor,
                    size: 30,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      userName!,
                      style: sidebarUser,
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('تغيير الاسم الأول'),
                              content: SizedBox(
                                child: TextFormField(
                                  controller: usernameController,
                                  decoration: const InputDecoration(
                                    hintText: 'قم بتغيير اسمك الأول',
                                  ),
                                ),
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
                                      onPressed: () {
                                        userID!
                                            .updateDisplayName(
                                                usernameController.text
                                                    .toString())
                                            .then((value) {});
                                        ref.doc(userID!.uid.toString()).update({
                                          'firstName': usernameController.text
                                              .toString(),
                                        }).then((value) {
                                          Navigator.pop(context);
                                        }).onError((error, stackTrace) {});
                                      },
                                      child: const Text('تغيير'),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      radius: 50,
                      borderRadius: BorderRadius.circular(50.0),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.edit,
                          color: kWhiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      userEmail!,
                      style: sidebarUser,
                    ),
                    const Spacer(),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Update Email'),
                                  content: SizedBox(
                                    child: TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        hintText: 'Edit your email',
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            userID!
                                                .updateEmail(emailController
                                                    .text
                                                    .toString())
                                                .then((value) {});
                                            ref
                                                .doc(userID!.uid.toString())
                                                .update({
                                              'email': emailController.text
                                                  .toString(),
                                            }).then((value) {
                                              Navigator.pop(context);
                                            }).onError((error, stackTrace) {});
                                          },
                                          child: const Text('Update'),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              });
                        },
                        radius: 50,
                        borderRadius: BorderRadius.circular(50.0),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.edit,
                            color: kWhiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('الإعدادات'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('تسجيل الخروج'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () async {
              final action = await AlertDialogs.yesCancelDialog(
                  context,
                  ' هل أنت متاكد من تسجيل الخروج؟ ',
                  'بالنقر على "تأكيد" سيتم تسجيل خروجك من تطبيق متزن  ');
              if (action == DialogsAction.yes) {
                await FirebaseAuth.instance.signOut();
                Get.to(() => const LogInScreen());
              }
            },
          ),
        ],
      ),
    );
  }
}
