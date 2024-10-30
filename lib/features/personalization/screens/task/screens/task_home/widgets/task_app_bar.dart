import 'package:aiu_project/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import '../../../../../../../utils/validators/validation.dart';

class TaskAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TaskAppBar({super.key, required this.drawerKey});

  final GlobalKey<SliderDrawerState> drawerKey;

  @override
  State<TaskAppBar> createState() => _TaskAppBarState();

  @override
  Size get preferredSize =>
      const Size.fromHeight(130); // Define the height you want for the app bar
}

class _TaskAppBarState extends State<TaskAppBar>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;

    return SizedBox(
      width: double.infinity,
      height: 130, // This height matches the preferredSize
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                  onPressed: () {
                    base.isEmpty
                        ? noTaskWarning(context)
                        : deleteAllTask(context);
                  },
                  icon: const Icon(
                    CupertinoIcons.trash_fill,
                    size: 40,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
