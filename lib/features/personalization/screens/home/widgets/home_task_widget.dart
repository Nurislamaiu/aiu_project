import 'package:aiu_project/features/personalization/screens/task/screens/task_new/task_new_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../../utils/constants/colors.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../../../models/task_model.dart';

class HomeTaskWidget extends StatefulWidget {
  const HomeTaskWidget({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  State<HomeTaskWidget> createState() => _HomeTaskWidgetState();
}

class _HomeTaskWidgetState extends State<HomeTaskWidget> {
  TextEditingController textEditingControllerForTitle = TextEditingController();
  TextEditingController textEditingControllerForSubTitle = TextEditingController();

  @override
  void initState() {
    textEditingControllerForTitle.text = widget.task.title;
    textEditingControllerForSubTitle.text = widget.task.subTitle;
    super.initState();
  }

  @override
  void dispose() {
    textEditingControllerForTitle.dispose();
    textEditingControllerForSubTitle.dispose();
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
              task: widget.task,
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        margin: const EdgeInsets.symmetric(vertical: TSizes.xs, horizontal: TSizes.sm),
        padding: const EdgeInsets.all(TSizes.xs),
        decoration: BoxDecoration(
          color: widget.task.isCompleted
              ? TColors.primaryTaskColor.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(TSizes.sm),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
          gradient: widget.task.isCompleted
              ? LinearGradient(
            colors: [
              TColors.primaryTaskColor.withOpacity(0.15),
              TColors.primaryTaskColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
        ),
        child: Row(
          children: [
            // Check Icon
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
                widget.task.save();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: widget.task.isCompleted
                      ? TColors.primaryTaskColor
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: TColors.grey, width: .8),
                ),
                child: Icon(
                  Icons.check,
                  color: widget.task.isCompleted ? TColors.white : Colors.transparent,
                  size: 18,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Task Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textEditingControllerForTitle.text,
                    style: TextStyle(
                      color: widget.task.isCompleted
                          ? TColors.primaryTaskColor
                          : TColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    textEditingControllerForSubTitle.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: widget.task.isCompleted
                          ? TColors.primaryTaskColor.withOpacity(0.7)
                          : TColors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ],
              ),
            ),

            // Date Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('hh:mm a, MMM d').format(widget.task.createdAtTime),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
