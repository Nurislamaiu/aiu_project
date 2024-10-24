import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

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
  late AnimationController animateController;
  bool isDrawerOpen = false;

  @override
  void initState() {
    animateController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    super.initState();
  }

  @override
  void dispose() {
    animateController.dispose();
    super.dispose();
  }

  /// OnToggle
  void onDrawerToggle() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        animateController.forward();
        widget.drawerKey.currentState!.openSlider();
      } else {
        animateController.reverse();
        widget.drawerKey.currentState!.closeSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 130, // This height matches the preferredSize
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: IconButton(
                  onPressed: onDrawerToggle,
                  icon: AnimatedIcon(
                      size: 40,
                      icon: AnimatedIcons.menu_close,
                      progress: animateController)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                  onPressed: () {
                    //
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
