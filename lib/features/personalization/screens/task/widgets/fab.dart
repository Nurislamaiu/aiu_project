import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class FAB extends StatelessWidget {
  const FAB({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // Func
        print('Task View');
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