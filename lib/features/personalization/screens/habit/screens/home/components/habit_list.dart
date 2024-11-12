import 'package:aiu_project/features/personalization/screens/habit/screens/detail/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/habit.dart';
import 'empty_tasks.dart';
import 'item/item.dart';

class HabitList extends StatefulWidget {
  HabitList({Key? key}) : super(key: key);

  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HabitModel>(
      builder: (context, data, child) {
        if (data.habits.length == 0) {
          return EmptyTask();
        }

        List<HabitItem> items = [];

        for (var item in data.habits) {
          items.add(HabitItem(
            key: ValueKey(item.id.toString()),
            id: item.id,
            name: item.name,
            time: item.time,
            dayList: item.daylist,
            data: item.data,
            toggleDate: (date) {
              Feedback.forTap(context);
              data.toggleDate(item, date);
            },
            onTap: () {
              Feedback.forTap(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Detail(),
                  settings:
                      RouteSettings(arguments: item), // Передача объекта Habit
                ),
              );
            },
          ));
        }

        return ReorderableListView(
          onReorder: data.reorderHabit,
          children: items,
        );
      },
    );
  }
}

