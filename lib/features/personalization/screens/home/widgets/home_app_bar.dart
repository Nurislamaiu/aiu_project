import 'package:flutter/material.dart';

import '../../../../../utils/device/device_utility.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, required this.title, required this.subTitle});

  final String title;
  final String subTitle;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}



class _HomeAppBarState extends State<HomeAppBar> {
  bool isNotification = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Привет, ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  widget.subTitle,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontSize: 8.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isNotification = !isNotification;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Icon(
                    isNotification
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_none_outlined,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

