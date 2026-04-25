import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_dto.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../utils/error_utils.dart';
import '../utils/token_storage.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

const Object _unset = Object();

class AuthState {
  final bool isInitializing;
  final bool isLoading;
  final bool isAuthenticated;
  final int? userId;
  final int? restaurantId;
  final String? role;
  final User? user;
  final String? error;

  const AuthState({
    this.isInitializing = true,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.userId,
    this.restaurantId,
    this.role,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isInitializing,
    bool? isLoading,
    bool? isAuthenticated,
    int? userId,
    int? restaurantId,
    String? role,
    User? user,
    Object? error = _unset,
  }) {
    return AuthState(
      isInitializing: isInitializing ?? this.isInitializing,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      role: role ?? this.role,
      user: user ?? this.user,
      error: identical(error, _unset) ? this.error : error as String?,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final token = await TokenStorage.getToken();
    final userId = await TokenStorage.getUserId();
    final role = await TokenStorage.getUserRole();

    if (kDebugMode) {
      debugPrint('[Auth] Bootstrap: token=${token != null && token.isNotEmpty ? 'EXISTS' : 'NONE'}, userId=$userId, role=$role');
    }

    if (token != null && token.isNotEmpty) {
      state = state.copyWith(
        isInitializing: false,
        isAuthenticated: true,
        userId: userId,
        restaurantId: await TokenStorage.getRestaurantId(),
        role: role,
      );
    } else {
      state = state.copyWith(isInitializing: false);
    }
  }

  Future<bool> login(String email, String password) {
    return _authenticate(
      () => _authService.login(LoginRequest(email: email, password: password)),
      failureMessage: 'Đăng nhập thất bại',
    );
  }

  Future<bool> register(String name, String email, String password) {
    return _authenticate(
      () => _authService.register(
        RegisterRequest(name: name, email: email, password: password),
      ),
      failureMessage: 'Đăng ký thất bại',
    );
  }

  Future<bool> _authenticate(
    Future<String?> Function() action, {
    required String failureMessage,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final token = await action();
      if (token == null || token.isEmpty) {
        state = state.copyWith(isLoading: false, error: failureMessage);
        return false;
      }

      final claims = _decodeJwt(token);
      final userId = _parseInt(claims?['sub']);
      final role = claims?['role']?.toString();
      final restaurantId = _parseInt(claims?['restaurantId']);

      if (kDebugMode) {
        debugPrint('[Auth] Login success: userId=$userId, role=$role');
      }

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userId: userId,
        restaurantId: restaurantId,
        role: role,
      );
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorUtils.message(error),
      );
      return false;
    }
  }

  Map<String, dynamic>? _decodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      return jsonDecode(decoded) as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AuthState(isInitializing: false);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final currentUserIdProvider = Provider<int?>((ref) {
  return ref.watch(authProvider).userId;
});

final currentRestaurantIdProvider = Provider<int?>((ref) {
  return ref.watch(authProvider).restaurantId;
});

final currentUserRoleProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).role;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});
