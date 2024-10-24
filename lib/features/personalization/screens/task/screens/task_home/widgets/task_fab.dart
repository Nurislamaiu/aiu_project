import 'package:aiu_project/features/personalization/screens/task/screens/task_new/task_new_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../../utils/constants/colors.dart';
import '../../../../../../../utils/constants/sizes.dart';
class FAB extends StatelessWidget {
  const FAB({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // Func
        Navigator.push(context, CupertinoPageRoute(builder: (context)=> TaskNewView()));
      },
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(TSizes.md),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
              color: TColors.primaryTaskColor,
              borderRadius: BorderRadius.circular(TSizes.md)),
          child: const Center(
            child: Icon(Icons.add, color: TColors.white),
          ),
        ),
      ),
    );
  }
}