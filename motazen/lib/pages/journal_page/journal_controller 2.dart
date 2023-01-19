import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:motazen/pages/journal_page/journal.dart';

class JournalController extends GetxController {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  var journalList = <JournalModel>[].obs;

  var isGettingJournals = false.obs;

  //Methods
  Future<void> getJournals() async {
    isGettingJournals(true);
    try {
      List<JournalModel> helperList = [];
      final journalsRef = FirebaseFirestore.instance
          .collection('user')
          .doc(currentUserId)
          .collection('journal')
          .orderBy(
            'createdAt',
            descending: true,
          );

      final journalsDate = await journalsRef.get();
      for (var element in journalsDate.docs) {
        helperList.add(JournalModel.fromMap(element.data()));
      }

      journalList.assignAll(helperList);
    } catch (e) {}
    isGettingJournals(false);
  }

  @override
  void onInit() {
    getJournals();
    super.onInit();
  }
}
