import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_string.dart';

class TextSpanSignUp extends StatelessWidget {
  const TextSpanSignUp({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 24,
            height: 24,
            child:
            Checkbox(value: true, onChanged: (value) {})),
        const SizedBox(width: TSizes.sm),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: '${TTexts.iAgreeTo} ',
                  style:
                  Theme.of(context).textTheme.labelMedium),
              TextSpan(
                text: '${TTexts.privatePolicy} ',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .apply(
                    decoration: TextDecoration.underline,
                    color: dark
                        ? TColors.white
                        : TColors.primary),
              ),
              TextSpan(
                  text: '${TTexts.and} ',
                  style:
                  Theme.of(context).textTheme.labelMedium),
              TextSpan(
                text: '${TTexts.termsOdUse}',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .apply(
                    decoration: TextDecoration.underline,
                    color: dark
                        ? TColors.white
                        : TColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
