import 'package:aiu_project/features/authentication/screens/login/login.dart';
import 'package:aiu_project/utils/constants/colors.dart';
import 'package:aiu_project/utils/helppers/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'features/personalization/screens/task/home_view_task.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          selectedIndex: controller.selectedIndex.value,
          elevation: 0,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: dark ? TColors.black : Colors.white,
          indicatorColor: dark
              ? TColors.white.withOpacity(0.1)
              : TColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.task), label: 'Store'),
            NavigationDestination(icon: Icon(Iconsax.heart), label: 'Wishlist'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    Container(color: Colors.green),
    HomeViewTask(),
    Container(color: Colors.red),
    Container(
      color: Colors.yellow,
      child: Center(
          child:
              IconButton(onPressed: () => signOut(), icon: Icon(Icons.delete_outline, color: Colors.black,))),
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

