import 'package:aiu_project/features/authentication/screens/onboarding/widgets/on_boarding_dot_navigation.dart';
import 'package:aiu_project/features/authentication/screens/onboarding/widgets/on_boarding_next_button.dart';
import 'package:aiu_project/features/authentication/screens/onboarding/widgets/on_boarding_skip.dart';
import 'package:aiu_project/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_string.dart';
import '../../../../utils/constants/text_string.dart';
import '../../controllers/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      backgroundColor: TColors.white,
      body: Stack(
        children: [
          // Horizontal Scrolling Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                  image: TImages.onBoardingImage1,
                  title: TTexts.onBoardingTitle1,
                  subTitle: TTexts.onBoardingSubTitle1),
              OnBoardingPage(
                  image: TImages.onBoardingImage2,
                  title: TTexts.onBoardingTitle2,
                  subTitle: TTexts.onBoardingSubTitle2),
              OnBoardingPage(
                  image: TImages.onBoardingImage3,
                  title: TTexts.onBoardingTitle3,
                  subTitle: TTexts.onBoardingSubTitle3),
            ],
          ),

          // Skip button
          const OnBoardingSkip(),

          const OnBoardingDotNavigation(),

          const OnBoardingNextButton()
        ],
      ),
    );
  }
}
