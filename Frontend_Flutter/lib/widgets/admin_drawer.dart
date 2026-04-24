import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/colors.dart';
import '../providers/auth_provider.dart';
import '../utils/auth_navigation.dart';
import '../utils/role_utils.dart';

class AdminDrawer extends ConsumerWidget {
  final String currentRoute;

  const AdminDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final role = normalizeRole(authState.role);
    final isAdmin = role == 'ADMIN';
    final panelTitle = isAdmin ? 'Admin Panel' : 'Staff Panel';

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.textDark, Color(0xFF343434)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(24),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    panelTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authState.user?.email ?? authState.role ?? 'ADMIN',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            _DrawerItem(
              icon: Icons.dashboard_outlined,
              label: 'Dashboard',
              selected: currentRoute == '/admin',
              onTap: () => _navigateTo(context, '/admin'),
            ),
            if (isAdmin)
              _DrawerItem(
                icon: Icons.people_outline,
                label: 'Users',
                selected: currentRoute == '/admin/users',
                onTap: () => _navigateTo(context, '/admin/users'),
              ),
            _DrawerItem(
              icon: Icons.storefront_outlined,
              label: 'Restaurants',
              selected: currentRoute == '/admin/restaurants',
              onTap: () => _navigateTo(context, '/admin/restaurants'),
            ),
            _DrawerItem(
              icon: Icons.category_outlined,
              label: 'Categories',
              selected: currentRoute == '/admin/categories',
              onTap: () => _navigateTo(context, '/admin/categories'),
            ),
            _DrawerItem(
              icon: Icons.bar_chart_outlined,
              label: 'Reports',
              selected: currentRoute == '/admin/reports',
              onTap: () => _navigateTo(context, '/admin/reports'),
            ),
            const Spacer(),
            const Divider(height: 1),
            _DrawerItem(
              icon: Icons.logout,
              label: 'Logout',
              danger: true,
              selected: false,
              onTap: () async {
                Navigator.pop(context);
                await logoutAndNavigateToLogin(context, ref);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context);
    if (currentRoute == route) {
      return;
    }
    Navigator.pushReplacementNamed(context, route);
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool danger;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger
        ? AppColors.danger
        : selected
        ? AppColors.primary
        : AppColors.textDark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        tileColor: selected ? AppColors.panel : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onTap: onTap,
      ),
    );
  }
}
