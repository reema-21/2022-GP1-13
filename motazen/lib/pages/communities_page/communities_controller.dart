import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../models/CommunityModel.dart';

class CommunitiesController extends GetxController {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  var communitiesList = <CommunityModel>[].obs;

  var isGettingCommunities = false.obs;

  //Methods
  Future<void> getCommunities() async {
    isGettingCommunities(true);
    try {
      List<CommunityModel> helperList = [];
      final communitiesRef =
          FirebaseFirestore.instance.collection('communities').orderBy(
                'creationDate',
                descending: true,
              );

      final communitiesData = await communitiesRef.get();
      for (var element in communitiesData.docs) {
        helperList.add(CommunityModel.fromMap(element.data()));
      }

      communitiesList.assignAll(helperList);
    } catch (e) {
      log('error: $e');
    }
    isGettingCommunities(false);
  }

  @override
  void onInit() {
    getCommunities();
    super.onInit();
  }
}
