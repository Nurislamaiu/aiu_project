import 'dart:io';

import 'package:aiu_project/app.dart';
import 'package:aiu_project/features/authentication/screens/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isUploading = false;
  String? profileImageUrl;

  static const Color primaryColor = Color(0xFF000DFF);
  static const Color secondaryColor = Color(0xFF5E5CE6);
  static const Color backgroundColor = Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>;
            profileImageUrl = userData!['avatar_url'];
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки данных: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      setState(() {
        isUploading = true;
      });

      try {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          String filePath = 'profile_pictures/${currentUser.uid}.jpg';
          UploadTask uploadTask =
          FirebaseStorage.instance.ref(filePath).putFile(imageFile);

          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .update({'avatar_url': downloadUrl});

          setState(() {
            profileImageUrl = downloadUrl;
          });
        }
      } catch (e) {
        Get.snackbar('Firebase Storage га акша жок', 'Ошибка загрузки изображения', colorText: Colors.white);
      } finally {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  Future<void> updateUserData(String field, String value) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({field: value});

        setState(() {
          userData![field] = value;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка обновления данных: $e')),
      );
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Здесь можно добавить навигацию на страницу входа
      print('Пользователь успешно вышел из системы');
    } catch (e) {
      print('Ошибка при выходе: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () async {
            await _signOut();
            // Навигация на страницу логина после выхода
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>LoginScreen()));
          }, icon: Icon(Icons.arrow_back_ios_new_rounded))
        ],
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Header gradient
          Container(
            height: 300,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
          ),
          SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : userData == null
                ? const Center(
              child: Text(
                'Не удалось загрузить данные пользователя',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
                : Column(
              children: [
                // Profile Image
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: pickProfileImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: profileImageUrl != null
                            ? NetworkImage(profileImageUrl!)
                            : null,
                        child: isUploading
                            ? const CircularProgressIndicator()
                            : profileImageUrl == null
                            ? SvgPicture.asset(
                          'assets/images/default_avatar.svg',
                          width: 100,
                          height: 100,
                        )
                            : null,
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Iconsax.camera,
                              color: primaryColor, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                // User details
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(50),
                          bottom: Radius.circular(50),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            EditableProfileField(
                              keyboardType: TextInputType.text,
                              label: 'Имя',
                              value: userData!['first_name'] ?? 'Не указано',
                              onChanged: (newValue) =>
                                  updateUserData('first_name', newValue),
                            ),
                            EditableProfileField(
                              keyboardType: TextInputType.text,
                              label: 'Фамилия',
                              value: userData!['last_name'] ?? 'Не указано',
                              onChanged: (newValue) =>
                                  updateUserData('last_name', newValue),
                            ),
                            EditableProfileField(
                              keyboardType: TextInputType.text,
                              label: 'Email',
                              value: userData!['email'] ?? 'Не указано',
                              onChanged: (newValue) =>
                                  updateUserData('email', newValue),
                            ),
                            EditableProfileField(
                              label: 'Телефон',
                              value: userData!['phone'] != null
                                  ? userData!['phone']
                                  : 'Не указано',
                              onChanged: (newValue) {
                                // Удаляем все лишние символы из ввода
                                String cleanValue = newValue.replaceAll(RegExp(r'[^0-9]'), '');

                                // Проверяем корректность номера
                                if (cleanValue.length == 11 && cleanValue.startsWith('7')) {
                                  // Форматируем номер
                                  String formattedPhone = '+7 (${cleanValue.substring(1, 4)}) '
                                      '${cleanValue.substring(4, 7)}-${cleanValue.substring(7, 9)}-${cleanValue.substring(9)}';

                                  // Сохраняем только корректный номер
                                  updateUserData('phone', formattedPhone);
                                } else {
                                  // Показываем сообщение об ошибке
                                  Get.snackbar('Ошибка', 'Введите корректный казахстанский номер телефона');
                                }
                              },
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                MaskTextInputFormatter(
                                  mask: '+7 (###) ###-####',
                                  filter: {"#": RegExp(r'[0-9]')},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}