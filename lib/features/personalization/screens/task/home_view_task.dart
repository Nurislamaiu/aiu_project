import 'package:aiu_project/common/extensions/space_exs.dart';
import 'package:aiu_project/features/personalization/screens/task/widgets/fab.dart';
import 'package:aiu_project/features/personalization/screens/task/widgets/home_view_task_body.dart';
import 'package:aiu_project/features/personalization/screens/task/widgets/task_widget.dart';
import 'package:aiu_project/utils/constants/image_string.dart';
import 'package:aiu_project/utils/constants/sizes.dart';
import 'package:aiu_project/utils/constants/text_string.dart';
import 'package:aiu_project/utils/helppers/helper_functions.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:lottie/lottie.dart';
import '../../../../utils/constants/colors.dart';

class HomeViewTask extends StatefulWidget {
  const HomeViewTask({super.key});

  @override
  State<HomeViewTask> createState() => _HomeViewTaskState();
}

class _HomeViewTaskState extends State<HomeViewTask> {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
        backgroundColor: TColors.white,

        // FAB
        floatingActionButton: FAB(),
        body: SliderDrawer(
            slider: Container(
              color: Colors.red,
            ),
            child: HomeViewTaskBody()));
  }
}
