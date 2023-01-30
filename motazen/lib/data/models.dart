import 'package:flutter/material.dart';

///------------------------------------------Models for to-do list---------------------------------------------

/// {@template todo}
/// Model for a todo. Can contain an optional list of [items] for
/// additional sub-todos.
/// {@endtemplate}
class Todo {
  /// {@macro todo}
  const Todo({
    required this.id,
    required this.description,
    required this.items,
  });

  /// The id of this todo.
  final String id;

  /// The description of this todo.
  final String description;

  /// A list of [Item]s for sub-todos.
  final List<Item> items;

  ///one-to-many
}

/// {@template item}
/// An individual item model, used within a [Todo].
/// {@endtemplate}
class Item {
  /// {@macro item}
  Item({
    this.importance,
    this.dueDate,
    this.daysCompletedTask,
    this.rank,
    required this.type,
    this.duration,
    this.itemGoal,
    required this.id,
    this.description = '',
    required this.completed,
    required this.icon, // tie in with aspect
  });

  /// The id of this item.
  final int id;

  /// The id of this item's goal.
  final int? itemGoal;

  /// Description of this item.
  final String description;

  /// Indicates if this item has been completed or not.
  bool completed;

  ///aspect icon
  final Widget icon;

  ///the duration of this item
  final int? duration;

  ///the importance of this item
  double? importance;

  /// the dependancy of the task
  double depandancies = 0;

  /// the importance of the goal
  double? rank = 0;

  /// the time left for the goal
  DateTime? dueDate;

  /// the amout of days a user has completed a task
  int? daysCompletedTask;

  ///the normalised time criteria
  double NT = 0;

  ///the normalised time criteria
  double timeLeft = 0;

  /// is the item a task or a habit
  final String type;
}

///------------------------------------------Models for piechart---------------------------------------------

class Data {
  ///rename to aspect
  final String name;

  final double points;

  final int color;

  final IconData icon;

  Data(
      {required this.name,
      this.points = 1.0,
      required this.color,
      required this.icon});
}
