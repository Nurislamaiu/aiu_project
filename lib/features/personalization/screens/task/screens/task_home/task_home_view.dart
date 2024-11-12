import 'package:aiu_project/features/personalization/screens/task/screens/task_home/widgets/task_app_bar.dart';
import 'package:aiu_project/features/personalization/screens/task/screens/task_home/widgets/task_fab.dart';
import 'package:aiu_project/features/personalization/screens/task/screens/task_home/widgets/task_widget.dart';
import 'package:aiu_project/main.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/image_string.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_string.dart';
import '../../../../models/task_model.dart';

class HomeViewTask extends StatefulWidget {
  const HomeViewTask({super.key});

  @override
  State<HomeViewTask> createState() => _HomeViewTaskState();
}

class _HomeViewTaskState extends State<HomeViewTask> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  dynamic valueOfIndicator(List<TaskModel> tasks){
    if(tasks.isNotEmpty){
      return tasks.length;
    }else{
      return 3;
    }
  }

  int checkDoneTask(List<TaskModel> tasks){
    int i = 0;
    for(TaskModel doneTask in tasks){
      if(doneTask.isCompleted){
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {

    final base = BaseWidget.of(context);

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<TaskModel> box, Widget? child) {
          var tasks = box.values.toList();
          tasks.sort((a,b)=>a.createdAtDate.compareTo(b.createdAtDate));
          return Scaffold(
              backgroundColor: TColors.white,

              // FAB
              floatingActionButton: FAB(),
              appBar: TaskAppBar(drawerKey: drawerKey),
              body: _buildHomeViewTaskBody(base, tasks));
        });
  }

  Widget _buildHomeViewTaskBody(
      BaseWidget base,
      List<TaskModel> tasks,
      ) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            // Custom App Bar
            SizedBox(
              width: double.infinity,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Progress indicator
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: CircularProgressIndicator(

                      value: checkDoneTask(tasks) / valueOfIndicator(tasks), // Example progress value
                      backgroundColor: Colors.grey,
                      valueColor:
                          const AlwaysStoppedAnimation(TColors.primaryTaskColor),
                    ),
                  ),
                  // Space
                  SizedBox(width: 25),
                  // Info Task Level
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        TTexts.taskTitle,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(height: 3),
                      Text(
                        "${checkDoneTask(tasks)} of ${valueOfIndicator(tasks)} Task", // Example text
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  )
                ],
              ),
            ),
            // Divider
            const Padding(
              padding: EdgeInsets.only(top: TSizes.sm),
              child: Divider(
                thickness: 2,
                indent: 100,
              ),
            ),
            // Tasks or Animation based on the list state
            Expanded(
              child: tasks.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeIn(
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: Lottie.asset(TImages.lottieUrl1,
                                animate: tasks
                                    .isEmpty), // Animation if list is empty
                          ),
                        ),
                        FadeInUp(
                          from: 30,
                          child: const Text(TTexts.doneAllTask),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        var task = tasks[index];
                        return Dismissible(
                          key: Key(task.id),
                          // Unique key for each item
                          direction: DismissDirection.horizontal,
                          onDismissed: (direction) {
                            base.dataStore.deleteTask(task: task);
                            // Optionally add a Snackbar or other notification
                          },
                          background: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_outline,
                                  color: TColors.grey),
                              SizedBox(width: 8),
                              Text(TTexts.deletedTask,
                                  style: TextStyle(color: TColors.grey)),
                            ],
                          ),
                          child: TaskWidget(
                            task: task,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
