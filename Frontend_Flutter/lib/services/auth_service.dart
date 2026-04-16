import 'package:dio/dio.dart';
import '../models/auth_dto.dart';
import '../models/user.dart';
import '../utils/token_storage.dart';
import 'dio_client.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  // Register
  Future<String?> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);
      final token = authResponse.token;

      if (token != null) {
        await TokenStorage.saveToken(token);
      }

      return token;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Login
  Future<String?> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: request.toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response.data);
      final token = loginResponse.token;

      if (token != null) {
        await TokenStorage.saveToken(token);
      }

      return token;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Logout
  Future<void> logout() async {
    await TokenStorage.clearToken();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await TokenStorage.getToken();
    return token != null;
  }

  // Get current user info from token
  Future<User?> getCurrentUser() async {
    final token = await TokenStorage.getToken();
    if (token == null) return null;

    try {
      final response = await _dio.get('/auth/me');
      return User.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data != null && data['message'] != null) {
        return data['message'];
      }
      return 'Lỗi server: ${e.response?.statusCode}';
    }
    return 'Không thể kết nối đến server';
  }
}
