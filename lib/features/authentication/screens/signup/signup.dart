import 'package:aiu_project/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:aiu_project/features/authentication/screens/signup/widgets/signup_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttpns.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_string.dart';
import '../../../../utils/helppers/helper_functions.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SignUpText(),
              const SizedBox(height: TSizes.spaceBtwSections),
              SignUpForm(dark: dark),
              const SizedBox(
                height: TSizes.spaceBtwItems + 10,
              ),
              TFormDivider(
                  dark: dark, dividerText: TTexts.orSignInWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}
