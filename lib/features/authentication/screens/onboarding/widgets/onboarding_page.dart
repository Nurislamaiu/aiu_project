import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helppers/helper_functions.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
              width: THelperFunctions.screenWidth() * 0.2,
              height: THelperFunctions.screenHeight() * 0.2,
              image: AssetImage(image)),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 56.0,
                fontWeight: FontWeight.w600,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            subTitle,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 26, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
