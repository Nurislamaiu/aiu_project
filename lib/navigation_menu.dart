import 'package:aiu_project/features/authentication/screens/login/login.dart';
import 'package:aiu_project/utils/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'features/personalization/screens/habit/screens/home/index.dart';
import 'features/personalization/screens/home/home_screen.dart';
import 'features/personalization/screens/task/screens/task_home/task_home_view.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Obx(
        () => CrystalNavigationBar(
          backgroundColor: Colors.grey.withOpacity(0.5),
          unselectedItemColor: TColors.black,
          selectedItemColor: Colors.white,
          indicatorColor: Colors.transparent,
          splashColor: Colors.transparent,
          items: [
            CrystalNavigationBarItem(icon: Iconsax.home),
            CrystalNavigationBarItem(icon: Iconsax.task),
            CrystalNavigationBarItem(
                icon: Iconsax.additem, selectedColor: Colors.blue),
            CrystalNavigationBarItem(icon: Iconsax.user),
            CrystalNavigationBarItem(icon: Iconsax.setting),
          ],
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.selectedIndex.value = index,
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    HomeScreen(),
    HomeViewTask(),
    Home(),
    Container(
      color: Colors.yellow,
      child: Center(
        child: IconButton(
          onPressed: () => signOut(),
          icon: Icon(Icons.delete_outline, color: Colors.black),
        ),
      ),
    ),
  ];
}

Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    print('Выход успешно выполнен');
    Get.to(LoginScreen());
  } catch (e) {
    print('Ошибка при выходе: $e');
  }
}
