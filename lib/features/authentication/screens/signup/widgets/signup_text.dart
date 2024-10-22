import 'package:flutter/material.dart';

import '../../../../../utils/constants/text_string.dart';

class SignUpText extends StatelessWidget {
  const SignUpText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(TTexts.signUpTitle,
        style: Theme.of(context).textTheme.headlineMedium);
  }
}