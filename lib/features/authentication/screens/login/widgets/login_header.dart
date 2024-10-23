import 'package:flutter/material.dart';

import '../../../../../utils/constants/image_string.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_string.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
            key: ValueKey(dark),
            height: 120,
            image: AssetImage(dark ? TImages.aiu : TImages.aiu)),
        Text(TTexts.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                color: dark ? Colors.white : Colors.black)),
        const SizedBox(height: TSizes.sm),
        Text(TTexts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
