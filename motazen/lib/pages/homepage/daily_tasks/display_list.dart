import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motazen/controllers/item_list_controller.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/models/todo_model.dart';
import 'package:motazen/pages/homepage/daily_tasks/create_list.dart';
import 'package:motazen/pages/homepage/daily_tasks/custom_rect_tween.dart';
import 'package:motazen/pages/homepage/daily_tasks/hero_dialog_route.dart';
import 'package:motazen/widget/list_popups.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import '../../goals_habits_tab/calculate_progress.dart';

///----------------------------------------Task Card----------------------------------------
class TaskTodoCard extends StatefulWidget {
  const TaskTodoCard({
    Key? key,
  }) : super(key: key);
  @override
  State<TaskTodoCard> createState() => _TaskTodoCardState();
}

class _TaskTodoCardState extends State<TaskTodoCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => const Center(child: _TaskTodoPopupCard()),
          ),
        );
      },
      child: Hero(
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        tag: 'todo-tag-1',
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Consumer<ItemListProvider>(
              builder: (context, value, child) => Material(
                color: Colors.white,
                elevation: 5.0,
                borderRadius: BorderRadius.circular(12),
                child: value.sublist.isEmpty
                    ? const Center(
                        child: Text('لا يوجد مهام مسجلة'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: (value.sublist.length),
                        itemBuilder: (context, index) {
                          return ListTile(
                            trailing: Checkbox(
                              onChanged: (bool? val) async {
                                if (value.sublist[index].completed) {
                                  //completed = true, then we need to decrement
                                  value.sublist[index].completed = false;
                                  if (value.sublist[index].daysCompletedTask !=
                                      null) {
                                    value.sublist[index].daysCompletedTask =
                                        value.sublist[index]
                                                .daysCompletedTask! -
                                            1;
                                  }
                                  await CalculateProgress()
                                      .updateAmountCompleted(
                                          value.sublist[index].id,
                                          value.sublist[index].itemGoal,
                                          'Decrement',
                                          value.sublist[index].type);
                                  await value.updateList();
                                } else {
                                  //completed = false, then we need to increment
                                  value.sublist[index].completed = true;
                                  if (value.sublist[index].daysCompletedTask !=
                                      null) {
                                    value.sublist[index].daysCompletedTask =
                                        value.sublist[index]
                                                .daysCompletedTask! +
                                            1;
                                  }
                                  await CalculateProgress()
                                      .updateAmountCompleted(
                                          value.sublist[index].id,
                                          value.sublist[index].itemGoal,
                                          'Increment',
                                          value.sublist[index].type);
                                  await value.updateList();
                                  bool isTaskCompleted =
                                      (value.sublist[index].duration -
                                              value.sublist[index]
                                                  .daysCompletedTask) ==
                                          0;
                                  if (context.mounted && isTaskCompleted) {
                                    //a user has finished a task
                                    showCupertinoDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) {
                                          return const ListDialog(
                                            title: 'اكتملت المهمة!',
                                            description:
                                                'كلام عن اكتمال المهمة',
                                            imagePath:
                                                'assets/animations/Complete_task.json',
                                          );
                                        });
                                  }
                                }
                              },
                              value: value.sublist[index].completed,
                              activeColor: kPrimaryColor,
                              checkColor: kWhiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            title: Text(
                              value.sublist[index].description,
                              style: TextStyle(
                                  color: value.sublist[index].type == 'Task' &&
                                          value.sublist[index].dueDate!
                                              .isBefore(DateTime.now())
                                      ? Colors.red
                                      : Colors.black,
                                  decoration: value.sublist[index].completed
                                      ? TextDecoration.lineThrough
                                      : null),
                            ),
                            leading: value.sublist[index].icon,
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskTodoPopupCard extends StatefulWidget {
  const _TaskTodoPopupCard();

  @override
  State<_TaskTodoPopupCard> createState() => __TaskTodoPopupCardState();
}

class __TaskTodoPopupCardState extends State<_TaskTodoPopupCard> {
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return Hero(
      tag: 'todo-tag-1',
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          child: Consumer<ItemListProvider>(
            builder: (context, value, child) => SizedBox(
              child: value.sublist.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('لا يوجد مهام مسجلة'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: (value.sublist.length),
                      itemBuilder: (context, index) {
                        return ListTile(
                          trailing: Checkbox(
                            onChanged: (bool? val) async {
                              if (value.sublist[index].completed) {
                                //completed = true, then we need to decrement
                                value.sublist[index].completed = false;
                                if (value.sublist[index].daysCompletedTask !=
                                    null) {
                                  value.sublist[index].daysCompletedTask =
                                      value.sublist[index].daysCompletedTask! -
                                          1;
                                }
                                await CalculateProgress().updateAmountCompleted(
                                    value.sublist[index].id,
                                    value.sublist[index].itemGoal,
                                    'Decrement',
                                    value.sublist[index].type);
                                await value.updateList();
                              } else {
                                //completed = false, then we need to increment
                                value.sublist[index].completed = true;
                                if (value.sublist[index].daysCompletedTask !=
                                    null) {
                                  value.sublist[index].daysCompletedTask =
                                      value.sublist[index].daysCompletedTask! +
                                          1;
                                }
                                await CalculateProgress().updateAmountCompleted(
                                    value.sublist[index].id,
                                    value.sublist[index].itemGoal,
                                    'Increment',
                                    value.sublist[index].type);
                                await value.updateList();
                                bool isTaskCompleted =
                                    (value.sublist[index].duration -
                                            value.sublist[index]
                                                .daysCompletedTask) ==
                                        0;
                                if (context.mounted && isTaskCompleted) {
                                  //a user has finished a task
                                  showCupertinoDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) {
                                        return const ListDialog(
                                          title: 'اكتملت المهمة!',
                                          description: 'كلام عن اكتمال المهمة',
                                          imagePath:
                                              'assets/animations/Complete_task.json',
                                        );
                                      });
                                }
                              }
                              setState(() {});
                            },
                            value: value.sublist[index].completed,
                            activeColor: kPrimaryColor,
                            checkColor: kWhiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          title: Text(
                            value.sublist[index].description,
                            style: TextStyle(
                                color: value.sublist[index].type == 'Task' &&
                                        value.sublist[index].dueDate!
                                            .isBefore(DateTime.now())
                                    ? Colors.red
                                    : Colors.black,
                                decoration: value.sublist[index].completed
                                    ? TextDecoration.lineThrough
                                    : null),
                          ),
                          leading: value.sublist[index].icon,
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class HabitTodoCard extends StatefulWidget {
  const HabitTodoCard({super.key, required this.aspectList});
  final List<Aspect> aspectList;
  @override
  State<HabitTodoCard> createState() => _HabitTodoCardState();
}

class _HabitTodoCardState extends State<HabitTodoCard> {
  @override
  Widget build(BuildContext context) {
    bool noHabits = true;
    ItemList().createHabitList(widget.aspectList);
    if (ItemList.dailyHabits.isNotEmpty ||
        ItemList.weeklyHabits.isNotEmpty ||
        ItemList.monthlyHabits.isNotEmpty ||
        ItemList.yearlyHabits.isNotEmpty) {
      noHabits = false;
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => const Center(
              child: _HabitTodoPopupCard(),
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
                child: noHabits
                    ? const Center(
                        child: Text('لا يوجد عادات مسجلة'),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            if (ItemList.dailyHabits.isNotEmpty)
                              const Text('عاداتي اليومية'),
                            if (ItemList.dailyHabits.isNotEmpty)
                              _TodoItemsBox(items: ItemList.dailyHabits),
                            if (ItemList.dailyHabits.isNotEmpty)
                              const Divider(),
                            if (ItemList.weeklyHabits.isNotEmpty)
                              const Text('عاداتي الأسبوعية'),
                            if (ItemList.weeklyHabits.isNotEmpty)
                              _TodoItemsBox(items: ItemList.weeklyHabits),
                            if (ItemList.weeklyHabits.isNotEmpty)
                              const Divider(),
                            if (ItemList.monthlyHabits.isNotEmpty)
                              const Text('عاداتي الشهرية'),
                            if (ItemList.monthlyHabits.isNotEmpty)
                              _TodoItemsBox(items: ItemList.monthlyHabits),
                            if (ItemList.monthlyHabits.isNotEmpty)
                              const Divider(),
                            if (ItemList.yearlyHabits.isNotEmpty)
                              const Text('عاداتي السنوية'),
                            if (ItemList.yearlyHabits.isNotEmpty)
                              _TodoItemsBox(items: ItemList.yearlyHabits),
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

class _HabitTodoPopupCard extends StatefulWidget {
  const _HabitTodoPopupCard();

  @override
  State<_HabitTodoPopupCard> createState() => __HabitTodoPopupCardState();
}

class __HabitTodoPopupCardState extends State<_HabitTodoPopupCard> {
  @override
  Widget build(BuildContext context) {
    bool noHabits = true;
    if (ItemList.dailyHabits.isNotEmpty ||
        ItemList.weeklyHabits.isNotEmpty ||
        ItemList.monthlyHabits.isNotEmpty ||
        ItemList.yearlyHabits.isNotEmpty) {
      noHabits = false;
    }
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
              child: noHabits
                  ? const Text('لا يوجد عادات مسجلة')
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (ItemList.dailyHabits.isNotEmpty)
                            const Text('عاداتي اليومية'),
                          if (ItemList.dailyHabits.isNotEmpty)
                            _TodoItemsBox(items: ItemList.dailyHabits),
                          if (ItemList.dailyHabits.isNotEmpty) const Divider(),
                          if (ItemList.weeklyHabits.isNotEmpty)
                            const Text('عاداتي الأسبوعية'),
                          if (ItemList.weeklyHabits.isNotEmpty)
                            _TodoItemsBox(items: ItemList.weeklyHabits),
                          if (ItemList.weeklyHabits.isNotEmpty) const Divider(),
                          if (ItemList.monthlyHabits.isNotEmpty)
                            const Text('عاداتي الشهرية'),
                          if (ItemList.monthlyHabits.isNotEmpty)
                            _TodoItemsBox(items: ItemList.monthlyHabits),
                          if (ItemList.monthlyHabits.isNotEmpty)
                            const Divider(),
                          if (ItemList.yearlyHabits.isNotEmpty)
                            const Text('عاداتي السنوية'),
                          if (ItemList.yearlyHabits.isNotEmpty)
                            _TodoItemsBox(items: ItemList.yearlyHabits),
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
