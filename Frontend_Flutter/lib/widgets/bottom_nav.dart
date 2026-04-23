import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../navigation/app_navigation.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  late final List<Widget> _screens = customerTabs
      .map((entry) => entry.builder())
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          for (final entry in customerTabs)
            BottomNavigationBarItem(icon: Icon(entry.icon), label: entry.label),
        ],
      ),
    );
  }
}
