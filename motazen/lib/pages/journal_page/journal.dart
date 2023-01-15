import 'dart:convert';

class JournalModel {
  String id;
  String title;
  String answer;
  String question;
  String createdAt;
  JournalModel({
    required this.id,
    required this.title,
    required this.answer,
    required this.question,
    required this.createdAt,
  });

  JournalModel copyWith({
    String? id,
    String? title,
    String? answer,
    String? question,
    String? createdAt,
  }) {
    return JournalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      answer: answer ?? this.answer,
      question: question ?? this.question,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'answer': answer,
      'question': question,
      'createdAt': createdAt,
    };
  }

  factory JournalModel.fromMap(Map<String, dynamic> map) {
    return JournalModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      answer: map['answer'] ?? '',
      question: map['question'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory JournalModel.fromJson(String source) =>
      JournalModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JournalModel(id: $id, title: $title, answer: $answer, question: $question, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JournalModel &&
        other.id == id &&
        other.title == title &&
        other.answer == answer &&
        other.question == question &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        answer.hashCode ^
        question.hashCode ^
        createdAt.hashCode;
  }
}
