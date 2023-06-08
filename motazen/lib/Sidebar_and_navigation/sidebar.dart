import 'dart:io';
//REEMAS
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motazen/controllers/auth_controller.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/controllers/edit_controller.dart';
import 'package:motazen/controllers/localtask_controller.dart';
import 'package:motazen/controllers/my_controller.dart';
import 'package:motazen/controllers/task_controller.dart';
import 'package:motazen/pages/homepage/daily_tasks/create_list.dart';
import 'package:motazen/pages/journal_page/journal_controller.dart';
import 'package:motazen/pages/login/login.dart';
import 'package:motazen/pages/settings/profile_edit.dart';
import 'package:motazen/pages/settings/setting_screen.dart';
import 'package:motazen/theme.dart';

import '../pages/assesment_page/alert_dialog.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  /// for update data
  CollectionReference ref = FirebaseFirestore.instance.collection('user');
  final ImagePicker _picker = ImagePicker();
  AuthController authController = Get.put(AuthController());
  File? file;

  /// Uploads an image file to Firebase storage and returns the download URL
  Future<String> uploadImage(File file, String userId) async {
    final storageRef =
        FirebaseStorage.instance.ref().child("user/profile/$userId.jpg");
    var uploadTask = await storageRef.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  /// Retrieves an image from the device gallery and sets it as the user's avatar
  Future<void> getImage() async {
    XFile? profileImage = await _picker.pickImage(source: ImageSource.gallery);
    if (profileImage == null) return;

    File imageFile = File(profileImage.path);
    String profileImageUrl =
        await uploadImage(imageFile, authController.currentUser.value.userID!);

    // Set the user's avatar URL in the AuthController
    authController.setUserAvatar(profileImageUrl);
  }

  @override
  void initState() {
    // If the user's avatar URL is not already available, fetch it
    if (authController.currentUser.value.avatarURL == null) {
      authController.getUserAvatar();
    }
    super.initState();
  }

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
                GestureDetector(
                  onTap: () async {
                    //  authController.getUserAvatar() ;
                    if (authController.currentUser.value.avatarURL == null ||
                        authController.currentUser.value.avatarURL == "") {
                      getImage();
                    }

                    //* pick the image

                    //      //* uplaod the image to the firebase storage
                    //      //! this should be moved to a method

                    //! the String url abouve should be saved in the user // you should create a controller for the user
                  },
                  child: CircleAvatar(
                    backgroundImage:
                        authController.currentUser.value.avatarURL == null ||
                                authController.currentUser.value.avatarURL == ""
                            ? null
                            : CachedNetworkImageProvider(
                                authController.currentUser.value.avatarURL!,
                                errorListener: () {}),
                    radius: 32,
                    backgroundColor: kWhiteColor,
                    child: authController.currentUser.value.avatarURL == null ||
                            authController.currentUser.value.avatarURL == ""
                        ? const Icon(
                            Icons.add_a_photo_outlined,
                            color: kBlackColor,
                            size: 30,
                          )
                        : null,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${FirebaseAuth.instance.currentUser!.displayName}',
                      style: sidebarUser,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StreamBuilder(
                      stream: firestore
                          .collection('user')
                          .doc(firebaseAuth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return snapshot.hasData &&
                                snapshot.data!['userName'] != null
                            ? Text(
                                snapshot.hasData
                                    ? snapshot.data!['userName']
                                    : '',
                                style: sidebarUser,
                              )
                            : const SizedBox();
                      },
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${FirebaseAuth.instance.currentUser!.email}',
                      style: sidebarUser,
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.to(() => const EditProfilePage());
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kWhiteColor,
                          fixedSize: const Size(130, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      child: const Text(
                        'تعديل الملف الشخصي',
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    )
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
                //! I might need to dispose of tasklist provider
                await FirebaseAuth.instance.signOut();
                ItemList().clearList();
                Get.delete<TaskLocalControleer>();
                Get.delete<TaskControleer>();
                Get.delete<MyControleer>();
                Get.delete<EditMyControleer>();
                Get.delete<JournalController>();
                Get.delete<CommunityController>();
                Get.delete<AuthController>();
                Get.to(() => const LogInScreen());
              }
            },
          ),
        ],
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
