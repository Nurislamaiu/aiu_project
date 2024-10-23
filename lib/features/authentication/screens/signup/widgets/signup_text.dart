import 'package:aiu_project/utils/helppers/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/text_string.dart';

class SignUpText extends StatelessWidget {
  const SignUpText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Text(TTexts.signUpTitle,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            color: dark ? Colors.white : Colors.black));
  }
}
