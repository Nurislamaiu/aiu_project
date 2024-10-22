import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helppers/helper_functions.dart';

class TCircularIcon extends StatelessWidget {
  const TCircularIcon({
    super.key,
    required this.icon,
    this.width,
    this.height,
    this.size = TSizes.lg,
    this.onPressed,
    this.color,
    this.backgroundColor,
  });

  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: backgroundColor ?? (THelperFunctions.isDarkMode(context)
                  ? TColors.black.withOpacity(0.7)
                  : TColors.white.withOpacity(0.9)),
        borderRadius: BorderRadius.circular(100)
      ),
      child: IconButton(onPressed: onPressed, icon: Icon(icon, color: color,size: size,)),
    );
  }
}
