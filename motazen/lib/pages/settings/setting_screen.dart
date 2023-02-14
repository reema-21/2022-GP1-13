import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/theme.dart';

import '../select_aspectPage/handle_aspect_data.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// appbar
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leadingWidth: 0.0,
        title: const Text(
          'الإعدادات',
          style: TextStyle(
            color: kWhiteColor,
            fontSize: 26,
          ),
        ),
      ),

      /// body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('إعادة التقييم'),
            onTap: () => Get.to(() => const initializeAspects()),
          ),
        ],
      ),
    );
  }
}
