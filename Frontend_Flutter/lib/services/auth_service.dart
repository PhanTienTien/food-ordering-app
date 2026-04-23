import 'package:dio/dio.dart';

import '../models/auth_dto.dart';
import '../utils/token_storage.dart';
import 'dio_client.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  Future<String?> register(RegisterRequest request) {
    return _authenticate('/auth/register', request.toJson());
  }

  Future<String?> login(LoginRequest request) {
    return _authenticate('/auth/login', request.toJson());
  }

  Future<void> logout() async {
    await TokenStorage.clearToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await TokenStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> _authenticate(
    String path,
    Map<String, dynamic> payload,
  ) async {
    final response = await _dio.post(path, data: payload);
    final data = response.data;

    if (data is! Map) {
      throw const FormatException('Invalid auth response');
    }

    final authResponse = AuthResponse.fromJson(Map<String, dynamic>.from(data));
    final token = authResponse.token;
    if (token != null && token.isNotEmpty) {
      await TokenStorage.saveToken(token);
    }
    return token;
  }
}
