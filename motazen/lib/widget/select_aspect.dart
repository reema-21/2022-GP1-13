import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  final List<QueryDocumentSnapshot> questionsLits = [];
  final List selectedQuestionsLits = [];

  bool _isLoading = true;
  @override
  initState() {
    super.initState();
    getQustions();
  }

  getQustions() async {
    final request =
        await FirebaseFirestore.instance.collection('aspect_Quastion').get();

    for (var e in request.docs) {
      questionsLits.add(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: questionsLits.length,
                        itemBuilder: (context, index) {
                          final question = questionsLits[index];
                          return CheckboxListTile(
                            value: selectedQuestionsLits.contains(question.id),
                            onChanged: (value) {
                              if (selectedQuestionsLits.contains(question.id)) {
                                selectedQuestionsLits.remove(question.id);
                              } else {
                                selectedQuestionsLits.add(question.id);
                              }
                              setState(() {});
                            },
                            title: Text(question.id),
                          );
                        }),
                  ),
                  ElevatedButton(
                      onPressed: selectedQuestionsLits.isEmpty
                          ? null
                          : () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => QuestionDetails(
                                          quesions: selectedQuestionsLits))));
                            },
                      child: const Text("NEXT"))
                ],
              ));
  }
}

class QuestionDetails extends StatelessWidget {
  final List quesions;

  const QuestionDetails({super.key, required this.quesions});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<QuerySnapshot<Map>>(
          future: FirebaseFirestore.instance
              .collection('aspect_Quastion')
              .where(FieldPath.documentId, whereIn: quesions)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final questionsList = [];
              final categories = snapshot.data!.docs;
              for (var element in categories) {
                element.get('1');
                questionsList.add(element.get('1'));
                questionsList.add(element.get('2'));
                questionsList.add(element.get('3'));
                questionsList.add(element.get('4'));
                if (element.data().containsKey('5')) {
                  questionsList.add(element.get('5'));
                }
              }
              return PageView(
                children: questionsList.map((e) => Text(e)).toList(),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
