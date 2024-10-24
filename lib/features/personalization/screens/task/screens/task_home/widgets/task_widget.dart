import 'package:flutter/material.dart';

import '../../../../../../../utils/constants/colors.dart';
import '../../../../../../../utils/constants/sizes.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          margin: const EdgeInsets.symmetric(
              vertical: TSizes.sm, horizontal: TSizes.md),
          decoration: BoxDecoration(
              color: TColors.primaryTaskColor.withOpacity(0.3),
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
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                decoration: BoxDecoration(
                  color: TColors.primaryTaskColor,
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
            title: const Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 3),
              child: Text(
                'Done',
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),

            // Task Description
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Description",
                  style: TextStyle(
                      color: TColors.black.withOpacity(0.5),
                      fontWeight: FontWeight.w300),
                ),

                // Date of Task
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: TSizes.sm, top: TSizes.sm),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Date
                        Text(
                          'Date',
                          style: TextStyle(fontSize: 14, color: TColors.black.withOpacity(0.5)),
                        ),

                        // Sub Date
                        Text(
                          'Sub Date',
                          style: TextStyle(fontSize: 14, color: TColors.black.withOpacity(0.5)),
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