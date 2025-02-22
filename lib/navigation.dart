import 'package:caffedict/features/analysis/screens/analysis_screen.dart';
import 'package:caffedict/features/analysis/screens/home_screen.dart';
import 'package:caffedict/features/personalization/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key, required this.isGuestUser});

  final bool isGuestUser;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController(isGuestUser: isGuestUser));

    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.selectedIndex.value = index,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(Iconsax.home),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(Iconsax.home_2),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(Iconsax.chart_2),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(Iconsax.chart_21),
              ),
              label: 'Analysis',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(Iconsax.user),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(Iconsax.user4),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final bool isGuestUser;

  NavigationController({required this.isGuestUser});

  late final List<Widget> screens = [
    HomeScreen(
      isGuestUser: isGuestUser,
    ),
    AnalysisScreen(
      isGuestUser: isGuestUser,
    ),
    ProfileScreen(
      isGuestUser: isGuestUser,
    ),
  ];
}
