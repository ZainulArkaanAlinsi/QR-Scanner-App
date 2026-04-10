import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/nav_item.dart';
import '../screens/tabs/home_tab.dart';
import '../screens/tabs/my_tickets_tab.dart';
import '../screens/tabs/events_tab.dart';
import '../screens/tabs/profile_tab.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;
  late List<NavItem> navItems;

  final bool isAdmin;

  NavigationController({required this.isAdmin});

  @override
  void onInit() {
    _initializeNavItems();
    super.onInit();
  }

  void _initializeNavItems() {
    navItems = [
      NavItem(
        title: 'Home',
        icon: Icons.home,
        screen: const HomeTab(),
      ),
      if (isAdmin)
        NavItem(
          title: 'Events',
          icon: Icons.campaign,
          screen: const EventsTab(),
        )
      else
        NavItem(
          title: 'My Tickets',
          icon: Icons.confirmation_num_outlined,
          screen: const MyTicketsTab(),
        ),
      NavItem(
        title: 'Profile',
        icon: Icons.person,
        screen: const ProfileTab(),
      ),
    ];
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
