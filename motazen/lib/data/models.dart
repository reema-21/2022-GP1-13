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
    required this.id,
    this.description = '',
    this.completed = false,
    required this.icon, // tie in with aspect
  });

  /// The id of this item.
  final String id;

  /// Description of this item.
  final String description;

  /// Indicates if this item has been completed or not.
  bool completed;

  ///aspect icon
  final Widget icon;
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
      this.points = 0.0,
      required this.color,
      required this.icon});
}
