import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_string.dart';
import '../verify_email.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final TextEditingController userIdController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();

    return Form(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: firstNameController,
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: TTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: lastNameController,
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: TTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: userIdController,
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.iin,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: emailController,
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: phoneController,
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: passwordController,
            obscureText: true,  // Скрываем пароль
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.password,
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: Icon(Iconsax.eye_slash),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () async {
                  // Валидация полей перед регистрацией
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      userIdController.text.isEmpty ||
                      firstNameController.text.isEmpty ||
                      lastNameController.text.isEmpty ||
                      phoneController.text.isEmpty) {
                    Get.snackbar('Error', 'All fields are required');
                    return;
                  }

                  await registerUser(
                      emailController.text,
                      passwordController.text,
                      userIdController.text,
                      firstNameController.text,
                      lastNameController.text,
                      phoneController.text);
                },
                child: const Text(TTexts.createAccount)),
          ),
        ],
      ),
    );
  }
}

Future<void> registerUser(String email, String password, String userId,
    String firstName, String lastName, String phone) async {
  try {
    FirebaseAuth.instance.setLanguageCode('en');  // Или другой язык, например 'ru'
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Сохраняем данные пользователя в Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'userId': userId,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
    });

    Get.to(() => const VerifyEmailScreen());
  } catch (e) {
    // Вывод ошибки через Snackbar
    Get.snackbar('Error', e.toString());
  }
}
