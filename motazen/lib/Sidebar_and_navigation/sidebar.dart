import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/pages/login/login.dart';
import 'package:motazen/theme.dart';
import '../pages/assesment_page/alert_dialog.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = FirebaseAuth.instance.currentUser!.displayName;
    final userEmail = FirebaseAuth.instance.currentUser!.email;
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName!),
            accountEmail: Text(userEmail!),
            currentAccountPicture: const CircleAvatar(),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.5),
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
                //return to the previouse page different code for the ios .
                // Navigator.push(context, MaterialPageRoute(builder: (context) {return homePag();}));
              } else {}
              await FirebaseAuth.instance.signOut();
              //AllDialogues.hideloading();
              Get.to(const LogInScreen());
            },
          ),
        ],
      ),
    );
  }
}
