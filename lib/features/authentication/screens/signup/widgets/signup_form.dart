import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:lottie/lottie.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_string.dart';
import '../../login/login.dart';

class SignUpForm extends StatefulWidget {
  final bool dark;

  const SignUpForm({super.key, required this.dark});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  bool isObscured = true; // Управление видимостью пароля
  bool _isLoading = false; // Управляет отображением индикатора загрузки

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: firstNameController,
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
                decoration: const InputDecoration(
                  labelText: TTexts.iin,
                  prefixIcon: Icon(Iconsax.user_edit),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: TTexts.email,
                  prefixIcon: Icon(Iconsax.direct),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [MaskedInputFormatter('(###) ###-####')],
                decoration: const InputDecoration(
                  labelText: TTexts.phoneNo,
                  prefixText: '+7 ',
                  prefixStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Iconsax.call),
                  hintText: '(XXX) XXX-XXXX',
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                controller: passwordController,
                obscureText: isObscured,
                decoration: InputDecoration(
                  labelText: TTexts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    icon: Icon(isObscured ? Iconsax.eye_slash : Iconsax.eye),
                    onPressed: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!validateFields()) {
                      Get.snackbar('Ошибка', 'Проверьте правильность заполнения полей');
                      return;
                    }
                    setState(() {
                      _isLoading = true; // Показать индикатор загрузки
                    });

                    await registerUser(
                      emailController.text,
                      passwordController.text,
                      userIdController.text,
                      firstNameController.text,
                      lastNameController.text,
                      phoneController.text,
                    );

                    setState(() {
                      _isLoading = false; // Скрыть индикатор загрузки
                    });
                  },
                  child: const Text(TTexts.createAccount),
                ),
              ),
            ],
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

  bool validateFields() {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        userIdController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        phoneController.text.isEmpty) {
      return false;
    }
    return true;
  }
}

Future<void> registerUser(String email, String password, String userId,
    String firstName, String lastName, String phone) async {
  try {
    // Проверка на уникальность userId
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: userId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      Get.snackbar('Ошибка', 'Этот User ID уже зарегистрирован');
      return;
    }

    // Регистрация пользователя в Firebase Auth
    FirebaseAuth.instance.setLanguageCode('en');
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Сохранение данных пользователя в Firestore
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

    Get.snackbar('Ураааа', 'Успешно зарегистрировались');
    Get.offAll(() => const LoginScreen());
  } catch (e) {
    Get.snackbar('Ошибка', e.toString());
  }
}
