import 'package:flutter/material.dart';

class TaskImportance {
  final Color color;
  final String title;
  final bool isChecked;

  TaskImportance({
    required this.color,
    required this.title,
    this.isChecked = false,
  });

  TaskImportance copyWith({
    Color? color,
    String? title,
    bool? isChecked,
  }) {
    return TaskImportance(
      color: color ?? this.color,
      title: title ?? this.title,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskImportance &&
        other.color == color &&
        other.title == title &&
        other.isChecked == isChecked;
  }

  @override
  int get hashCode => color.hashCode ^ title.hashCode ^ isChecked.hashCode;
}
