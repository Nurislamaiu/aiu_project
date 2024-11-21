import 'package:aiu_project/features/authentication/screens/login/login.dart';
import 'package:aiu_project/navigation_menu.dart';
import 'package:aiu_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Добавьте эту строку, если используете Firebase

class App extends StatelessWidget {
  App({super.key});

  Future<bool> _isUserLoggedIn() async {
    final user = FirebaseAuth.instance.currentUser; // Проверяем текущего пользователя
    return user != null; // Возвращаем true, если пользователь есть
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Показать индикатор загрузки пока проверка выполняется
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          // Показать сообщение об ошибке, если она возникла
          return const Center(child: Text('Ошибка при проверке пользователя'));
        }

        // Перенаправить на LoginScreen, если пользователь не найден
        if (snapshot.data == false) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            theme: TAppTheme.lightTheme,
            darkTheme: TAppTheme.darkTheme,
            home: const LoginScreen(),
          );
        }

        // Перенаправить на NavigationMenu, если пользователь найден
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          home: const NavigationMenu(),
        );
      },
    );
  }
}
