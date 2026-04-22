import 'package:dio/dio.dart';
import '../utils/token_storage.dart';
import 'dio_client.dart';

class FavoriteService {
  final Dio _dio = DioClient().dio;

  Future<List<dynamic>> getFavoritesByUser(int userId) async {
    try {
      final response = await _dio.get('/favorites/user/$userId');
      return response.data as List;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> addFavorite(int userId, int menuItemId) async {
    try {
      await _dio.post(
        '/favorites',
        queryParameters: {
          'userId': userId,
          'menuItemId': menuItemId,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> removeFavorite(int userId, int menuItemId) async {
    try {
      await _dio.delete(
        '/favorites',
        queryParameters: {
          'userId': userId,
          'menuItemId': menuItemId,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> isFavorite(int userId, int menuItemId) async {
    try {
      final response = await _dio.get(
        '/favorites/check',
        queryParameters: {
          'userId': userId,
          'menuItemId': menuItemId,
        },
      );
      return response.data as bool;
    } on DioException catch (e) {
      return false;
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
