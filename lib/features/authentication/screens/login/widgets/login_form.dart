import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_string.dart';
import '../../password_configuration/forget_password.dart';
import '../../signup/signup.dart';

class TLoginForm extends StatefulWidget {
  const TLoginForm({super.key});

  @override
  _TLoginFormState createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Управляет отображением индикатора загрузки
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
            child: Column(
              children: [
                TextFormField(
                  controller: userIdController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: TTexts.iin,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    labelText: TTexts.password,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields / 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.to(() => const ForgetPassword()),
                      child: const Text(TTexts.forgetPassword),
                    )
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true; // Показать индикатор загрузки
                      });

                      await loginWithIdAndPassword(
                          userIdController.text, passwordController.text);

                      setState(() {
                        _isLoading = false; // Скрыть индикатор загрузки
                      });
                    },
                    child: const Text(TTexts.signIn),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Get.to(() => const SignupScreen()),
                    child: const Text(TTexts.createAccount),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Center(
            child: Lottie.asset(
              'assets/lottie/loading.json', // Укажите путь к вашему JSON-файлу Lottie
              width: 150,
              height: 150,
            ),
          ),
      ],
    );
  }
}

Future<void> loginWithIdAndPassword(String userId, String password) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: userId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      String email = snapshot.docs.first['email'];

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Get.offAll(() => const NavigationMenu());
      print('Logged in as: ${userCredential.user!.email}');
    } else {
      Get.snackbar('Ошибка', 'Этот User ID не зарегистрировался');
      print('User ID not found');
    }
  } catch (e) {
    Get.snackbar('Ошибка', 'Ошибка входа. Проверьте данные.');
    print('Error: $e');
  }
}
