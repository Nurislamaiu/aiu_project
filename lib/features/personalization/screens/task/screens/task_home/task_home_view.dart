import 'package:aiu_project/features/personalization/screens/task/screens/task_home/widgets/task_app_bar.dart';
import 'package:aiu_project/features/personalization/screens/task/screens/task_home/widgets/task_fab.dart';
import 'package:aiu_project/features/personalization/screens/task/screens/task_home/widgets/task_home_view_body.dart';
import 'package:aiu_project/features/personalization/screens/task/screens/task_home/widgets/task_slider_drawer.dart';
import 'package:aiu_project/utils/helppers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import '../../../../../../utils/constants/colors.dart';

class HomeViewTask extends StatefulWidget {
  const HomeViewTask({super.key});

  @override
  State<HomeViewTask> createState() => _HomeViewTaskState();
}

class _HomeViewTaskState extends State<HomeViewTask> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
        backgroundColor: TColors.white,

        // FAB
        floatingActionButton: FAB(),
        body: SliderDrawer(
          key: drawerKey,
            isDraggable: false,
            animationDuration: 1000,
            appBar: TaskAppBar(drawerKey: drawerKey,),
            slider: TaskSliderDrawer(),
            child: HomeViewTaskBody()));
  }
}
