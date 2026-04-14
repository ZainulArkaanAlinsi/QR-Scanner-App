import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../controllers/navigation_controller.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    // Initialize NavigationController with user role
    final navCtrl = Get.put(NavigationController(isAdmin: auth.isAdmin));

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: navCtrl.currentIndex.value,
            children: navCtrl.navItems.map((item) => item.screen).toList(),
          )),
      bottomNavigationBar: Obx(() => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: NavigationBar(
              selectedIndex: navCtrl.currentIndex.value,
              onDestinationSelected: navCtrl.changeIndex,
              animationDuration: const Duration(milliseconds: 500),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: navCtrl.navItems
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, size: 24),
                      ),
                      label: item.title,
                    ),
                  )
                  .toList(),
            ),
          )),
    );
  }
}
