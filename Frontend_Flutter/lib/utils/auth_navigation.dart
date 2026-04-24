import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';

Future<void> logoutAndNavigateToLogin(
  BuildContext context,
  WidgetRef ref,
) async {
  await ref.read(authProvider.notifier).logout();
  if (!context.mounted) {
    return;
  }

  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (route) => false,
  );
}
