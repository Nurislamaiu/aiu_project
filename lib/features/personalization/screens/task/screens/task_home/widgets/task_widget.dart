import 'package:aiu_project/features/personalization/screens/task/screens/task_new/task_new_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../../utils/constants/colors.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../../../../../models/task_model.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TextEditingController textEditingControllerForTitle = TextEditingController();
  TextEditingController textEditingControllerForSubTitle =
      TextEditingController();

  @override
  void initState() {
    textEditingControllerForTitle.text = widget.task.title;
    textEditingControllerForSubTitle.text = widget.task.subTitle;
    super.initState();
  }

  @override
  void dispose() {
    textEditingControllerForTitle.dispose;
    textEditingControllerForSubTitle.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (ctx) => TaskNewView(
                titleTaskController: textEditingControllerForTitle,
                descriptionTaskController: textEditingControllerForSubTitle,
                task: widget.task),
          ),
        );
      },
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          margin: const EdgeInsets.symmetric(
              vertical: TSizes.sm, horizontal: TSizes.md),
          decoration: BoxDecoration(
              color: widget.task.isCompleted
                  ? TColors.primaryTaskColor.withOpacity(0.3)
                  : Colors.white,
              borderRadius: BorderRadius.circular(TSizes.sm),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    offset: const Offset(0, 4),
                    blurRadius: 10)
              ]),
          child: ListTile(
            // Check Icon
            leading: GestureDetector(
              onTap: () {
                // Check or unCheck
                widget.task.isCompleted = !widget.task.isCompleted;
                widget.task.save();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                decoration: BoxDecoration(
                  color: widget.task.isCompleted
                      ? TColors.primaryTaskColor
                      : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: TColors.grey, width: .8),
                ),
                child: const Icon(
                  Icons.check,
                  color: TColors.white,
                ),
              ),
            ),

            // Task Title
            title: Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 3),
              child: Text(
                textEditingControllerForTitle.text,
                style: TextStyle(
                    color: widget.task.isCompleted
                        ? TColors.primaryTaskColor
                        : TColors.black,
                    fontWeight: FontWeight.w500,
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),

            // Task Description
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textEditingControllerForSubTitle.text,
                  style: TextStyle(
                      color: widget.task.isCompleted
                          ? TColors.primaryTaskColor
                          : TColors.black,
                      fontWeight: FontWeight.w300,
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null),
                ),

                // Date of Task
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: TSizes.sm, top: TSizes.sm),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Date
                        Text(
                          DateFormat('hh:mm a')
                              .format(widget.task.createdAtTime),
                          style: TextStyle(
                              fontSize: 14,
                              color: widget.task.isCompleted
                                  ? Colors.white
                                  : Colors.grey),
                        ),

                        // Sub Date
                        Text(
                          DateFormat.yMMMEd().format(widget.task.createdAtDate),
                          style: TextStyle(
                              fontSize: 14,
                              color: widget.task.isCompleted
                                  ? Colors.white
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
