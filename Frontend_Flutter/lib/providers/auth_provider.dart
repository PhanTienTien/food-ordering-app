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
  final String? role;
  final User? user;
  final String? error;

  const AuthState({
    this.isInitializing = true,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.userId,
    this.role,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isInitializing,
    bool? isLoading,
    bool? isAuthenticated,
    int? userId,
    String? role,
    User? user,
    Object? error = _unset,
  }) {
    return AuthState(
      isInitializing: isInitializing ?? this.isInitializing,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
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
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        state = state.copyWith(
          isAuthenticated: true,
          userId: await TokenStorage.getUserId(),
          role: await TokenStorage.getUserRole(),
        );
      }
    } finally {
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

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userId: await TokenStorage.getUserId(),
        role: await TokenStorage.getUserRole(),
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

final currentUserRoleProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).role;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});
