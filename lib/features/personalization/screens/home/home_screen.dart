import 'package:aiu_project/common/extensions/space_exs.dart';
import 'package:aiu_project/features/personalization/models/task_model.dart';
import 'package:aiu_project/features/personalization/screens/home/widgets/home_app_bar.dart';
import 'package:aiu_project/features/personalization/screens/home/widgets/home_calendar_widget.dart';
import 'package:aiu_project/features/personalization/screens/home/widgets/home_task_widget.dart';
import 'package:aiu_project/features/personalization/screens/task/screens/task_home/widgets/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../../main.dart';
import '../../../../utils/constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final base = BaseWidget.of(context);
    return ValueListenableBuilder(
      valueListenable: base.dataStore.listenToTask(),
      builder: (ctx, Box<TaskModel> box, Widget? child) {
        var tasks = box.values.toList();
        tasks.sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));

        // Limit the tasks list to only the last two added
        var recentTasks = tasks.reversed.take(2).toList();

        return Scaffold(
          appBar: HomeAppBar(
            title: 'Нурлибай Жандос Сакенулы',
            subTitle: 'ИС-25А - Информационные системы',
          ),
          body: homeScreenTodo(base, recentTasks),
        );
      },
    );
  }

  Widget homeScreenTodo(BaseWidget base, List<TaskModel> tasks) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: TColors.primaryTaskColor,
                  borderRadius: BorderRadius.circular(15)),
              height: 100,
              width: double.infinity,
              child: Text(
                'data',
                style: TextStyle(color: TColors.primaryTaskColor),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('На сегодня'),
                Text(
                  'Посмотреть все',
                  style: TextStyle(color: TColors.primaryTaskColor),
                ),
              ],
            ),

            /// HOME TASK (Displaying only last two tasks)
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 100, // Set your desired minimum height here
                ),
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    var task = tasks[index];
                    return Dismissible(
                      key: Key(task.id),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        base.dataStore.deleteTask(task: task);
                      },
                      child: HomeTaskWidget(task: task),
                    );
                  },
                ),
              ),
            ),


            /// CALENDAR
            CalendarScreen(),
          ],
        ),
      ),
    );
  }
}
