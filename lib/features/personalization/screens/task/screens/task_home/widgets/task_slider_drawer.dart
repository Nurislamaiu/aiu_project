import 'dart:developer';

import 'package:aiu_project/common/extensions/space_exs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../../utils/constants/colors.dart';

class TaskSliderDrawer extends StatelessWidget {
  TaskSliderDrawer({super.key});

  final List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  final List<String> texts = ["Home", "Profile", "Settings", "Details"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: TColors.primaryGradientTaskColor,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                "https://i.pinimg.com/originals/c9/e4/b3/c9e4b3822cb96cab091698094d020cd7.jpg"),
          ),
          8.h,
          Text("Nurislam", style: Theme.of(context).textTheme.displayMedium),
          Text("Flutter Dev", style: Theme.of(context).textTheme.displaySmall),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
                itemCount: icons.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      log(texts[index] + ' Item Tapped');
                    },
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: ListTile(
                        leading: Icon(
                          icons[index],
                          color: Colors.white,
                          size: 30,
                        ),
                        title: Text(
                          texts[index],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
