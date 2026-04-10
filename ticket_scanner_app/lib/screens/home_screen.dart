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
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: navCtrl.currentIndex.value,
            onTap: navCtrl.changeIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF1A237E),
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            items: navCtrl.navItems
                .map((item) => BottomNavigationBarItem(
                      icon: Icon(item.icon),
                      label: item.title,
                    ))
                .toList(),
          )),
    );
  }
}
