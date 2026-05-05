import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

Future<void> logoutAndNavigateToLogin(
  BuildContext context,
  WidgetRef ref,
) async {
  await ref.read(authProvider.notifier).logout();
}
