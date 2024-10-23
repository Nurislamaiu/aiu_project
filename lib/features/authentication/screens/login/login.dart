import 'package:aiu_project/features/authentication/screens/login/widgets/login_form.dart';
import 'package:aiu_project/features/authentication/screens/login/widgets/login_header.dart';
import 'package:flutter/material.dart';
import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              TLoginHeader(dark: dark),
              const TLoginForm(),
              TFormDivider(dark: dark, dividerText: '',),
            ],
          ),
        ),
      ),
    );
  }
}


