import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/setting_screen.dart';
import '../screens/order_history_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/admin_users_screen.dart';
import '../screens/admin/admin_restaurants_screen.dart';
import '../screens/admin/admin_categories_screen.dart';
import '../screens/staff/staff_orders_screen.dart';
import '../screens/staff/staff_menu_screen.dart';

class RoleBasedNav extends ConsumerStatefulWidget {
  const RoleBasedNav({super.key});

  @override
  ConsumerState<RoleBasedNav> createState() => _RoleBasedNavState();
}

class _RoleBasedNavState extends ConsumerState<RoleBasedNav> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userRole = ref.watch(currentUserProvider)?.role ?? 'CUSTOMER';
    final userId = ref.watch(currentUserProvider)?.id ?? 0;

    // Get screens based on role
    final screens = _getScreensForRole(userRole, userId);
    final navItems = _getNavItemsForRole(userRole);

    // Ensure currentIndex is valid
    if (_currentIndex >= screens.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: navItems,
      ),
    );
  }

  List<Widget> _getScreensForRole(String role, int userId) {
    switch (role) {
      case 'ADMIN':
        return [
          const AdminDashboardScreen(),
          const AdminUsersScreen(),
          const AdminRestaurantsScreen(),
          const AdminCategoriesScreen(),
          const SettingScreen(),
        ];
      case 'STAFF':
        // TODO: Get actual restaurantId from user data
        const restaurantId = 1;
        return [
          StaffOrdersScreen(
            restaurantId: restaurantId,
            staffId: userId,
          ),
          StaffMenuScreen(restaurantId: restaurantId),
          const SettingScreen(),
        ];
      case 'CUSTOMER':
      default:
        return [
          HomeScreen(),
          const CartScreen(),
          const OrderHistoryScreen(),
          const FavoriteScreen(),
          const SettingScreen(),
        ];
    }
  }

  List<BottomNavigationBarItem> _getNavItemsForRole(String role) {
    switch (role) {
      case 'ADMIN':
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Restaurants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ];
      case 'STAFF':
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ];
      case 'CUSTOMER':
      default:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ];
    }
  }
}
