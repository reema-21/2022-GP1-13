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
import 'package:motazen/pages/homepage/daily_tasks/create_list.dart';
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
  final userID = FirebaseAuth.instance.currentUser;

  /// for update data
  CollectionReference ref = FirebaseFirestore.instance.collection('user');
  final ImagePicker _picker = ImagePicker();
  AuthController authController = Get.find();

  File? file;
  //! i think i should first fetch the current users avatar and have the value so that if user cking

  Future<void> getImage() async {
    XFile? profileImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(profileImage!.path);
    });

    //* uplaod the image to the firebase storage
    //! this should be moved to a method
    final user = FirebaseAuth.instance.currentUser;
    final storageRef =
        FirebaseStorage.instance.ref().child("user/profile/${user!.uid}.jpg");
    var uploadTask = await storageRef.putFile(file!);
    String profileImageUrl = await uploadTask.ref.getDownloadURL();

// here lets set the value of user avatar
    setState(() {
      authController.currentUser.value.avatarURL = profileImageUrl;
    });
    authController.setUserAvatar(profileImageUrl);
  }

  @override
  void initState() {
    authController.getUserAvatar();
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

          // UserAccountsDrawerHeader(
          //   accountName: SizedBox(
          //     height: 50,
          //     width: MediaQuery.of(context).size.width,
          //     child: Padding(
          //       padding: const EdgeInsets.only(top: 30.0),
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: [
          //           Text(
          //             userName!,
          //             style: sidebarUser,
          //           ),
          //           Spacer(),
          //           InkWell(
          //             onTap: () {
          //               Navigator.pop(context);
          //               showDialog(
          //                   context: context,
          //                   builder: (BuildContext context) {
          //                     return AlertDialog(
          //                       title: Text('Update Username'),
          //                       content: SizedBox(
          //                         child: TextFormField(
          //                           controller: usernameController,
          //                           decoration: InputDecoration(
          //                             hintText: 'Edit your name',
          //                           ),
          //                         ),
          //                       ),
          //                       actions: [
          //                         TextButton(
          //                           onPressed: () {
          //                             Navigator.pop(context);
          //                           },
          //                           child: Text('Cancel'),
          //                         ),
          //                         TextButton(
          //                           onPressed: () {
          //                             userID!.updateDisplayName(usernameController.text.toString()).then((value) {
          //                               print('Update Username Successfully');
          //                             });
          //                             ref.doc(userID!.uid.toString()).update({
          //                               'firstName' : usernameController.text.toString(),
          //                             }).then((value) {
          //                               print('Update Username Successfully');
          //                               Navigator.pop(context);
          //                             }).onError((error, stackTrace) {
          //                               print(error.toString());
          //                             });
          //                           },
          //                           child: Text('Update'),
          //                         ),
          //                       ],
          //                     );
          //                   });
          //             },
          //             radius: 50,
          //             borderRadius: BorderRadius.circular(50.0),
          //             child: const Padding(
          //               padding: EdgeInsets.all(8.0),
          //               child: Icon(
          //                 Icons.edit,
          //                 color: kWhiteColor,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          //   accountEmail: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Text(
          //         userEmail!,
          //         style: sidebarUser,
          //       ),
          //       Material(
          //         color: Colors.transparent,
          //         child: InkWell(
          //           onTap: () {
          //             Navigator.pop(context);
          //             showDialog(
          //                 context: context,
          //                 builder: (BuildContext context) {
          //                   return AlertDialog(
          //                     title: Text('Update Email'),
          //                     content: SizedBox(
          //                       child: TextFormField(
          //                         controller: emailController,
          //                         decoration: InputDecoration(
          //                           hintText: 'Edit your email',
          //                         ),
          //                       ),
          //                     ),
          //                     actions: [
          //                       TextButton(
          //                         onPressed: () {
          //                           Navigator.pop(context);
          //                         },
          //                         child: Text('Cancel'),
          //                       ),
          //                       TextButton(
          //                         onPressed: () {
          //                           userID!.updateEmail(emailController.text.toString()).then((value) {
          //                             print('Email Updated Successfully');
          //                           });
          //                           ref.doc(userID!.uid.toString()).update({
          //                             'email' : emailController.text.toString(),
          //                           }).then((value) {
          //                             print('Email Updated Successfully');
          //                             Navigator.pop(context);
          //                           }).onError((error, stackTrace) {
          //                             print(error.toString());
          //                           });
          //                         },
          //                         child: Text('Update'),
          //                       ),
          //                     ],
          //                   );
          //                 });
          //           },
          //           radius: 50,
          //           borderRadius: BorderRadius.circular(50.0),
          //           child: const Padding(
          //             padding: EdgeInsets.all(12.0),
          //             child: Icon(
          //               Icons.edit,
          //               color: kWhiteColor,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          //   currentAccountPicture: const CircleAvatar(
          //       backgroundColor: kWhiteColor,
          //       child: Icon(
          //         Icons.person,
          //         color: kBlackColor,
          //         size: 30,
          //       ),),
          //   decoration: const BoxDecoration(
          //     color: kPrimaryColor,
          //   ),
          // ),
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
                ItemList().clearList();
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
