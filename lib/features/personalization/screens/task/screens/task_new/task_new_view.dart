import 'dart:developer';

import 'package:aiu_project/common/extensions/space_exs.dart';
import 'package:aiu_project/features/personalization/screens/task/screens/task_new/widgets/date_time_selection.dart';
import 'package:aiu_project/features/personalization/screens/task/screens/task_new/widgets/rep_text_field.dart';
import 'package:aiu_project/features/personalization/screens/task/screens/task_new/widgets/task_new_view_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/text_string.dart';

class TaskNewView extends StatefulWidget {
  const TaskNewView({super.key});

  @override
  State<TaskNewView> createState() => _TaskNewViewState();
}

class _TaskNewViewState extends State<TaskNewView> {
  final TextEditingController titleTaskController = TextEditingController();
  final TextEditingController descriptionTaskController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        /// AppBar
        appBar: TaskNewViewAppBar(),

        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Side Text
                _buildTopSideTexts(),

                /// Main Task View Activity
                _buildMainTaskViewActivity(
                    titleTaskController: titleTaskController,
                    descriptionTaskController: descriptionTaskController),

                /// Bottom Side Buttons

                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /// Delete Current Task
                      MaterialButton(
                        onPressed: () {},
                        minWidth: 150,
                        height: 55,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: TColors.white,
                        child: Row(
                          children: [
                            const Icon(Icons.close,
                                color: TColors.primaryTaskColor),
                            5.w,
                            const Text(
                              TTexts.deleteTask,
                              style: TextStyle(color: TColors.primaryTaskColor),
                            ),
                          ],
                        ),
                      ),

                      /// Add or Update Task
                      MaterialButton(
                        onPressed: () {},
                        minWidth: 150,
                        height: 55,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: TColors.primaryTaskColor,
                        child: const Text(
                          TTexts.addTaskString,
                          style: TextStyle(color: TColors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _buildMainTaskViewActivity extends StatelessWidget {
  const _buildMainTaskViewActivity({
    super.key,
    required this.titleTaskController,
    required this.descriptionTaskController,
  });

  final TextEditingController titleTaskController;
  final TextEditingController descriptionTaskController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              TTexts.titleOfTitleTextField,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          10.h,

          /// Task Title
          RepTextField(controller: titleTaskController),
          10.h,

          /// Task Description
          RepTextField(
            controller: descriptionTaskController,
            isForDescription: true,
          ),

          /// Time Selection
          DateTimeSelectionWidget(
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                // Handle the selected time here
                log(pickedTime.format(context));
              }
            },
            title: TTexts.timeString,
          ),
          DateTimeSelectionWidget(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2028),
              );
              if (pickedDate != null) {
                // Handle the selected time here
                log(pickedDate.toString());
              }
            },
            title: TTexts.dateString,
          ),
        ],
      ),
    );
  }
}

class _buildTopSideTexts extends StatelessWidget {
  const _buildTopSideTexts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
          RichText(
              text: TextSpan(
                  text: TTexts.addNewTask,
                  style: Theme.of(context).textTheme.titleLarge,
                  children: [
                TextSpan(
                    text: TTexts.taskString,
                    style: TextStyle(fontWeight: FontWeight.w400))
              ])),
        ],
      ),
    );
  }
}
