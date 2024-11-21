import 'package:aiu_project/features/authentication/screens/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

import '../../../../utils/constants/image_string.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_string.dart';
import '../../../../utils/helppers/helper_functions.dart';

class ResetPassword extends StatefulWidget {
  final String email;

  const ResetPassword({super.key, required this.email});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _sendPasswordResetEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: widget.email);
      Get.snackbar(
        "Успех",
        "Ссылка для сброса пароля отправлена на ${widget.email}.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Ошибка",
        e.message ?? "Произошла ошибка.",
        backgroundColor: Colors.transparent,
        colorText: Colors.black,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  Image(
                    image: const AssetImage(TImages.verificationEmail),
                    width: THelperFunctions.screenWidth() * 0.5,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Text(
                    TTexts.resetPasswordTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: dark ? Colors.white : Colors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    "На ваш ${widget.email} была отправлена ссылка для сброса пароля.",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.offAll(() => LoginScreen()),
                      child: const Text(TTexts.done),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _sendPasswordResetEmail,
                      child: const Text(TTexts.resendEmail),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: Lottie.asset(
                'assets/lottie/loading.json', // Укажите ваш файл анимации
                width: 150,
                height: 150,
              ),
            ),
        ],
      ),
    );
  }
}
