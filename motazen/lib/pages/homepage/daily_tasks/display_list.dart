import 'package:flutter/material.dart';
import 'package:motazen/models/todo_model.dart';
import 'package:motazen/pages/homepage/daily_tasks/custom_rect_tween.dart';
import 'package:motazen/pages/homepage/daily_tasks/hero_dialog_route.dart';
import 'package:motazen/theme.dart';
import '../../goals_habits_tab/calculate_progress.dart';

///----------------------------------------Task Card----------------------------------------
/// {@template todo_card}
/// Card that display a [Todo]'s content.
///
/// On tap it opens a [HeroDialogRoute] with [_TodoPopupCard] as the content.
/// {@endtemplate}
class TaskTodoCard extends StatelessWidget {
  /// {@macro todo_card}
  const TaskTodoCard({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => Center(
              child: _TaskTodoPopupCard(todo: todo),
            ),
          ),
        );
      },
      child: Hero(
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        tag: todo.id,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
              color: Colors.white,
              elevation: 5.0,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _TodoItemsBox(items: todo.items),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// {@template todo_popup_card}
/// Popup card to expand the content of a [Todo] card.
///
/// Activated from [TodoCard].
/// {@endtemplate}
class _TaskTodoPopupCard extends StatelessWidget {
  const _TaskTodoPopupCard({Key? key, required this.todo}) : super(key: key);
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: todo.id,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TodoItemsBox(items: todo.items),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///------------------------------------------------Habit Card---------------------------
///----------------------------------------Task Card----------------------------------------
/// {@template todo_card}
/// Card that display a [Todo]'s content.
///
/// On tap it opens a [HeroDialogRoute] with [_TodoPopupCard] as the content.
/// {@endtemplate}
class HabitTodoCard extends StatelessWidget {
  /// {@macro todo_card}
  const HabitTodoCard({
    Key? key,
    required this.daysTodo,
    required this.weeksTodo,
    required this.monthsTodo,
    required this.yearsTodo,
  }) : super(key: key);

  final Todo? daysTodo;
  final Todo? weeksTodo;
  final Todo? monthsTodo;
  final Todo? yearsTodo;

  @override
  Widget build(BuildContext context) {
    bool noHabits = true;
    if (daysTodo != null ||
        weeksTodo != null ||
        monthsTodo != null ||
        yearsTodo != null) {
      noHabits = false;
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => Center(
              child: _HabitTodoPopupCard(
                daysTodo: daysTodo,
                monthsTodo: monthsTodo,
                weeksTodo: weeksTodo,
                yearsTodo: yearsTodo,
                noHabits: noHabits,
              ),
            ),
          ),
        );
      },
      child: Hero(
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        tag: 2,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
              color: Colors.white,
              elevation: 5.0,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      if (daysTodo != null) const Text('عاداتي اليومية'),
                      if (daysTodo != null)
                        _TodoItemsBox(items: daysTodo!.items),
                      if (daysTodo != null) const Divider(),
                      if (weeksTodo != null) const Text('عاداتي الأسبوعية'),
                      if (weeksTodo != null)
                        _TodoItemsBox(items: weeksTodo!.items),
                      if (weeksTodo != null) const Divider(),
                      if (monthsTodo != null) const Text('عاداتي الشهرية'),
                      if (monthsTodo != null)
                        _TodoItemsBox(items: monthsTodo!.items),
                      if (monthsTodo != null) const Divider(),
                      if (yearsTodo != null) const Text('عاداتي السنوية'),
                      if (yearsTodo != null)
                        _TodoItemsBox(items: yearsTodo!.items),
                      if (noHabits) const Text('لا يوجد عادات مسجلة'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// {@template todo_popup_card}
/// Popup card to expand the content of a [Todo] card.
///
/// Activated from [TodoCard].
/// {@endtemplate}
class _HabitTodoPopupCard extends StatelessWidget {
  const _HabitTodoPopupCard(
      {Key? key,
      this.daysTodo,
      this.weeksTodo,
      this.monthsTodo,
      this.yearsTodo,
      required this.noHabits})
      : super(key: key);
  final Todo? daysTodo;
  final Todo? weeksTodo;
  final Todo? monthsTodo;
  final Todo? yearsTodo;
  final bool noHabits;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 2,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (daysTodo != null) const Text('عاداتي اليومية'),
                    if (daysTodo != null) _TodoItemsBox(items: daysTodo!.items),
                    if (daysTodo != null) const Divider(),
                    if (weeksTodo != null) const Text('عاداتي الأسبوعية'),
                    if (weeksTodo != null)
                      _TodoItemsBox(items: weeksTodo!.items),
                    if (weeksTodo != null) const Divider(),
                    if (monthsTodo != null) const Text('عاداتي الشهرية'),
                    if (monthsTodo != null)
                      _TodoItemsBox(items: monthsTodo!.items),
                    if (monthsTodo != null) const Divider(),
                    if (yearsTodo != null) const Text('عاداتي السنوية'),
                    if (yearsTodo != null)
                      _TodoItemsBox(items: yearsTodo!.items),
                    if (noHabits) const Text('لا يوجد عادات مسجلة'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// {@template todo_items_box}
/// Box containing the list of a [Todo]'s items.
///
/// These items can be checked.
/// {@endtemplate}
class _TodoItemsBox extends StatelessWidget {
  /// {@macro todo_items_box}
  const _TodoItemsBox({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items) _TodoItemTile(item: item),
      ],
    );
  }
}

/// {@template todo_item_template}
/// An individual [Todo] [Item] with its [Checkbox].
/// {@endtemplate}
class _TodoItemTile extends StatefulWidget {
  /// {@macro todo_item_template}
  const _TodoItemTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  _TodoItemTileState createState() => _TodoItemTileState();
}

class _TodoItemTileState extends State<_TodoItemTile> {
  void _onChanged(bool? val) {
    setState(() {
      if (widget.item.completed) {
        //completed = true, then we need to decrement
        widget.item.completed = false;
        CalculateProgress().updateAmountCompleted(widget.item.id,
            widget.item.itemGoal, 'Decrement', widget.item.type);
      } else {
        //completed = false, then we need to increment
        widget.item.completed = true;
        CalculateProgress().updateAmountCompleted(widget.item.id,
            widget.item.itemGoal, 'Increment', widget.item.type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Checkbox(
        onChanged: _onChanged,
        value: widget.item.completed,
        activeColor: kPrimaryColor,
        checkColor: kWhiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      title: Text(
        widget.item.description,
        style: TextStyle(
            color: widget.item.type == 'Task' &&
                    widget.item.dueDate!.isBefore(DateTime.now())
                ? Colors.red
                : Colors.black,
            decoration:
                widget.item.completed ? TextDecoration.lineThrough : null),
      ),
      leading: widget.item.icon,
    );
  }
}
