import 'dart:developer';

import 'package:aiu_project/common/extensions/space_exs.dart';
import 'package:aiu_project/features/personalization/models/task_model.dart';
import 'package:aiu_project/features/personalization/screens/task/screens/task_new/widgets/date_time_selection.dart';
import 'package:aiu_project/features/personalization/screens/task/screens/task_new/widgets/rep_text_field.dart';
import 'package:aiu_project/features/personalization/screens/task/screens/task_new/widgets/task_new_view_app_bar.dart';
import 'package:aiu_project/main.dart';
import 'package:aiu_project/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/text_string.dart';

class TaskNewView extends StatefulWidget {
  const TaskNewView({
    super.key,
    required this.titleTaskController,
    required this.descriptionTaskController,
    required this.task,
  });

  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final TaskModel? task;

  @override
  State<TaskNewView> createState() => _TaskNewViewState();
}

class _TaskNewViewState extends State<TaskNewView> {
  late TextEditingController titleTaskController;
  late TextEditingController descriptionTaskController;

  @override
  void initState() {
    super.initState();
    titleTaskController = widget.titleTaskController ?? TextEditingController();
    descriptionTaskController =
        widget.descriptionTaskController ?? TextEditingController();
  }
  bool isTaskAlreadyExits() {
    return titleTaskController.text.isEmpty &&
        descriptionTaskController.text.isEmpty;
  }



  var title;
  var subTitle;
  DateTime? time;
  DateTime? date;

  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  /// Main Function for creating or updating tasks
  dynamic isTaskAlreadyExistUpdateOtherWiseCreate() {
    /// HERE WE UPDATE CURRENT TASK
    if (widget.titleTaskController?.text != null &&
        widget.descriptionTaskController?.text != null) {
      try {
        widget.titleTaskController?.text = title;
        widget.descriptionTaskController?.text = subTitle;
        widget.task?.save();

        /// TODO: pop page
      } catch (e) {
        updateTaskWarning(context);
      }

      /// HERE WE CREATE A NEW TASK
    } else {
      if (title != null && subTitle != null) {
        var task = TaskModel.create(
            title: title,
            subTitle: subTitle,
            createdAtTime: time,
            createdAtDate: date);

        /// We are adding this new task to HIVE DB using inherited widget
        BaseWidget.of(context).dataStore.addTask(task: task);

        /// TODO: pop page
      } else {
        emptyWarning(context);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleTaskController.dispose();
    descriptionTaskController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: TaskNewViewAppBar(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopSideTexts(context, isTaskAlreadyExits()),
                _buildMainTaskViewActivity(
                  context,
                  titleTaskController,
                  descriptionTaskController,
                ),
                _buildBottomSideButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSideTexts(BuildContext context, bool isTaskAlreadyExits) {
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
              text: isTaskAlreadyExits
                  ? TTexts.addNewTask
                  : TTexts.updateCurrentTask,
              style: Theme.of(context).textTheme.titleLarge,
              children: [
                TextSpan(
                  text: TTexts.taskString,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainTaskViewActivity(
    BuildContext context,
    TextEditingController titleTaskController,
    TextEditingController descriptionTaskController,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              TTexts.titleOfTitleTextField,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          10.h,

          /// Task Title
          RepTextField(
            controller: titleTaskController,
            onFieldSubmitted: (String inputTitle) {
              title = inputTitle;
            },
            onChange: (String inputTitle) {
              title = inputTitle;
            },
          ),
          10.h,

          /// Task Description
          RepTextField(
            controller: descriptionTaskController,
            isForDescription: true,
            onFieldSubmitted: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
            onChange: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
          ),

          /// Time Selection
          DateTimeSelectionWidget(
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              setState(() {
                if (pickedTime != null) {
                  final now = DateTime.now();
                  final selectedDateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  if (widget.task?.createdAtTime == null) {
                    // Присваиваем значение локальной переменной time
                    time = selectedDateTime;
                  } else {
                    // Присваиваем значение свойству createdAtTime модели task
                    widget.task!.createdAtTime = selectedDateTime;
                  }
                }
              });

            },
            title: TTexts.timeString,
            time: showTime(time),
          ),

          DateTimeSelectionWidget(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: showDateAsDateTime(date),
                firstDate: DateTime.now(),
                lastDate: DateTime(2028),
              );

              if (pickedDate != null) {
                setState(() {
                  if (widget.task?.createdAtDate == null) {
                    // Присваиваем значение локальной переменной date
                    date = pickedDate;
                  } else {
                    // Присваиваем значение свойству createdAtDate модели task
                    widget.task!.createdAtDate = pickedDate;
                  }
                });
              }
            },
            title: TTexts.dateString,
            time: showDate(date),
          ),

        ],
      ),
    );
  }

  Widget _buildBottomSideButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExits()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          /// Delete Current Task
          isTaskAlreadyExits()
              ? Container()
              : MaterialButton(
                  onPressed: () {},
                  minWidth: 150,
                  height: 55,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: TColors.white,
                  child: Row(
                    children: [
                      const Icon(Icons.close, color: TColors.primaryTaskColor),
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
            onPressed: () {
              isTaskAlreadyExistUpdateOtherWiseCreate();
            },
            minWidth: 150,
            height: 55,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: TColors.primaryTaskColor,
            child: const Text(
              TTexts.addTaskString,
              style: TextStyle(color: TColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
