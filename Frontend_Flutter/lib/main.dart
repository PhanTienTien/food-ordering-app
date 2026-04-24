import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/admin/admin_categories_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_restaurants_screen.dart';
import 'screens/admin/admin_users_screen.dart';
import 'screens/login_screen.dart';
import 'screens/staff/staff_home_screen.dart';
import 'utils/role_utils.dart';
import 'widgets/bottom_nav.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routes: {
        '/admin': (_) => const AdminDashboardScreen(),
        '/admin/users': (_) => const AdminUsersScreen(),
        '/admin/restaurants': (_) => const AdminRestaurantsScreen(),
        '/admin/categories': (_) => const AdminCategoriesScreen(),
        '/admin/reports': (_) => const _PlaceholderScreen(title: 'Admin Reports'),
      },
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final role = normalizeRole(authState.role);

    if (authState.isInitializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!authState.isAuthenticated) {
      return const LoginScreen();
    }

    if (role == 'ADMIN') {
      return const AdminDashboardScreen();
    }

    if (role == 'STAFF') {
      return const StaffHomeScreen();
    }

    return const BottomNav();
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: Text('Screen not implemented yet')),
    );
  }
}
