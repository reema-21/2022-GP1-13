import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/pages/journal_page/journal.dart';
import 'package:motazen/pages/journal_page/journal_controller.dart';
import 'package:motazen/theme.dart';

class AddJournalScreen extends StatefulWidget {
  const AddJournalScreen({Key? key, this.journal}) : super(key: key);
  final JournalModel? journal;

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final JournalController journalController = Get.find<JournalController>();
  late bool isEditing;
  late TextEditingController titleController;
  late TextEditingController answerController;
  late String question;

  final List<String> questions = [
    'ما المشتتات التي عانيت منها اليوم اثناء اكمال مهامك؟',
    'ماذا حققت اليوم؟ هل انت فخور بعملك؟',
    'ما الذي يمكنك فعله لتحسين أداء عملك غدا؟',
    'ماذا تعلمت اليوم اثناء اكمال مهامك؟',
    'ما هو اكثر جزء من يومك تستمتع به؟ هل قمت به اليوم؟',
  ];

  bool isloading = false;
  bool isDeleting = false;

  @override
  void initState() {
    isEditing = widget.journal == null ? false : true;
    titleController = TextEditingController(text: widget.journal?.title);
    answerController = TextEditingController(text: widget.journal?.answer);
    question = widget.journal?.question ?? (questions..shuffle()).first;
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                question = (questions..shuffle()).first;
              });
            },
            child: const Text('تغيير السؤال'),
          ),
          isloading
              ? const CupertinoActivityIndicator()
              : TextButton(
                  onPressed: () async {
                    setState(() {
                      isloading = true;
                    });
                    try {
                      final currentUserId =
                          FirebaseAuth.instance.currentUser!.uid;
                      DocumentReference<Map<String, dynamic>> journalRef;
                      if (isEditing) {
                        journalRef = FirebaseFirestore.instance
                            .collection('user')
                            .doc(currentUserId)
                            .collection('journal')
                            .doc(widget.journal!.id);
                      } else {
                        journalRef = FirebaseFirestore.instance
                            .collection('user')
                            .doc(currentUserId)
                            .collection('journal')
                            .doc();
                      }

                      final journal = JournalModel(
                        id: journalRef.id,
                        title: titleController.text.isEmpty
                            ? 'Journal'
                            : titleController.text.trim(),
                        answer: answerController.text.trim(),
                        question: question,
                        createdAt: DateTime.now().toIso8601String(),
                      );

                      await journalRef.set(journal.toMap());
                      if (isEditing) {
                        journalController.journalList.remove(widget.journal);
                      }
                      journalController.journalList.insert(
                        0,
                        journal,
                      );
                      Get.back();
                    } catch (e) {}
                    setState(() {
                      isloading = false;
                    });
                  },
                  child: const Text(
                    'انتهاء',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(
                24,
              ),
              elevation: 2,
              color: const Color(0xffF2FAFD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  30,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(
                        fontSize: 28,
                        color: kBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'عنوان المذكرة',
                        hintStyle: TextStyle(
                          fontSize: 28,
                          color: kBlackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      question,
                      style: const TextStyle(
                        fontSize: 16,
                        color: kBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: answerController,
                      style: const TextStyle(
                        fontSize: 16,
                        color: kBlackColor,
                      ),
                      maxLines: null,
                      decoration: const InputDecoration.collapsed(
                        hintText: '',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isEditing)
            Padding(
              padding: const EdgeInsets.only(
                bottom: 24,
                left: 24,
                right: 24,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isDeleting = true;
                  });
                  try {
                    final currentUserId =
                        FirebaseAuth.instance.currentUser!.uid;
                    final journalRef = FirebaseFirestore.instance
                        .collection('user')
                        .doc(currentUserId)
                        .collection('journal')
                        .doc(widget.journal!.id);

                    await journalRef.delete();
                    journalController.journalList.remove(widget.journal);
                    Get.back();

                    Get.back();
                  } catch (e) {}
                  setState(() {
                    isDeleting = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                child: isDeleting
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : const Text(
                        'حذف المذكرة',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
