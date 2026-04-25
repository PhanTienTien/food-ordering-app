import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../utils/auth_navigation.dart';
import 'staff_menu_screen.dart';
import 'staff_orders_screen.dart';

class StaffHomeScreen extends ConsumerStatefulWidget {
  const StaffHomeScreen({super.key});

  @override
  ConsumerState<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends ConsumerState<StaffHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final restaurantId = authState.restaurantId;
    final staffId = authState.userId;

    if (restaurantId == null || staffId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Staff Panel')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Staff account is not linked to a restaurant.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => logoutAndNavigateToLogin(context, ref),
                  child: const Text('Back to login'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final screens = [
      StaffOrdersScreen(restaurantId: restaurantId, staffId: staffId),
      StaffMenuScreen(restaurantId: restaurantId),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Panel - Restaurant #$restaurantId'),
        actions: [
          IconButton(
            onPressed: () => logoutAndNavigateToLogin(context, ref),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
