import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/pages/journal_page/add_journal.dart';
import 'package:motazen/pages/journal_page/journal_controller.dart';
import 'package:motazen/theme.dart';

class Journal extends StatelessWidget {
  Journal({super.key});
  final JournalController journalController = Get.put(JournalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          textDirection: TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'مذكرتي',
              style: titleText,
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                Get.to(() => const AddJournalScreen());
              },
              child: Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: kPrimaryColor,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'اضافة مذكرة جديدة',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: Obx(
                () => journalController.isGettingJournals.value
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemCount: journalController.journalList.length,
                        itemBuilder: (context, index) {
                          final journal = journalController.journalList[index];
                          final journalDate = DateTime.parse(journal.createdAt);
                          return InkWell(
                            onTap: () {
                              Get.to(() => AddJournalScreen(
                                    journal: journal,
                                  ));
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Card(
                                    color: Colors.grey[100],
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        journal.title,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  'مذكرة ${journalDate.day}/${journalDate.month}/${journalDate.year}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 0, 187, 255),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
