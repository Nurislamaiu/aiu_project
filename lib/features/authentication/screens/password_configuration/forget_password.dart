import 'package:aiu_project/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_string.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  Future<void> _checkEmailExists() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Ошибка", "Введите адрес электронной почты.",
          backgroundColor: Colors.transparent,
          colorText: Colors.black);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _auth.fetchSignInMethodsForEmail(email);
      if (user.isNotEmpty) {
        Get.off(() => ResetPassword(email: email));
      } else {
        final userDoc = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (userDoc.docs.isNotEmpty) {
          Get.off(() => ResetPassword(email: email));
        } else {
          Get.snackbar(
              "Ошибка", "Электронная почта не найдена в наших записях.",
              backgroundColor: Colors.transparent,
              colorText: Colors.black);
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Ошибка", e.message ?? "Произошла ошибка",
          backgroundColor: Colors.transparent,
          colorText: Colors.black);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: dark ? Colors.white : Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(TTexts.forgetPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: dark ? Colors.white : Colors.black)),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(TTexts.forgetPasswordSubTitle,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: TSizes.spaceBtwSections * 2),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: TTexts.email,
                prefixIcon: const Icon(Iconsax.direct_right),
                suffixIcon: _isLoading
                    ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Lottie.asset(
                    'assets/lottie/loading.json',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                )
                    : null,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? () {} : _checkEmailExists,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text(TTexts.submit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
