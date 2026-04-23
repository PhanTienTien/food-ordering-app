import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/colors.dart';
import '../navigation/app_navigation.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/notifications_screen.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final displayName = authState.user?.name;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            accountName: Text(
              displayName != null && displayName.isNotEmpty
                  ? displayName
                  : 'User ${authState.userId ?? ''}',
            ),
            accountEmail: Text(authState.role ?? 'CUSTOMER'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
            ),
          ),
          ...customerDrawerEntries.map(
            (entry) =>
                _buildItem(context, entry.icon, entry.label, entry.builder()),
          ),
          _buildItem(
            context,
            Icons.notifications,
            'Notifications',
            const NotificationsScreen(),
          ),
          const Spacer(),
          _buildItem(
            context,
            Icons.logout,
            'Logout',
            const LoginScreen(),
            isLogout: true,
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (!context.mounted) {
                return;
              }
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget screen, {
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : AppColors.primary),
      title: Text(title),
      onTap: () {
        if (onTap != null) {
          onTap();
          return;
        }
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
    );
  }
}
