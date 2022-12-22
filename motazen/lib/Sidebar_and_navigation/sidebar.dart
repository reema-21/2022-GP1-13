import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/pages/login/login.dart';
import 'package:motazen/theme.dart';

import '../pages/assesment_page/alert_dialog.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    /// see documentation
    final userName = FirebaseAuth.instance.currentUser!.displayName;
    final userEmail = FirebaseAuth.instance.currentUser!.email;
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Container(
              margin: const EdgeInsets.only(
                top: 23,
              ),
              child: Text(
                userName!,
                style: sidebarUser,
              ),
            ),
            accountEmail: Text(
              userEmail!,
              style: sidebarUser,
            ),
            currentAccountPicture: const CircleAvatar(
                backgroundColor: kWhiteColor,
                child: Icon(
                  Icons.person,
                  color: kBlackColor,
                  size: 30,
                )),
            decoration: const BoxDecoration(
              color: kPrimaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('الإعدادات'),
            onTap: () => null,
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
