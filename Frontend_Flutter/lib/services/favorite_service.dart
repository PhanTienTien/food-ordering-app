import 'package:dio/dio.dart';
import '../utils/error_utils.dart';
import '../models/favorite_item.dart';
import 'dio_client.dart';

class FavoriteService {
  final Dio _dio = DioClient().dio;

  Future<List<FavoriteItem>> getFavoritesByUser(int userId) async {
    try {
      final response = await _dio.get('/favorites/user/$userId');
      final List<dynamic> data = response.data;
      return data.map((json) => FavoriteItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<void> addFavorite(int userId, int menuItemId) async {
    try {
      await _dio.post(
        '/favorites',
        queryParameters: {'userId': userId, 'menuItemId': menuItemId},
      );
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<void> removeFavorite(int userId, int menuItemId) async {
    try {
      await _dio.delete(
        '/favorites',
        queryParameters: {'userId': userId, 'menuItemId': menuItemId},
      );
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<bool> isFavorite(int userId, int menuItemId) async {
    try {
      final response = await _dio.get(
        '/favorites/check',
        queryParameters: {'userId': userId, 'menuItemId': menuItemId},
      );
      return response.data as bool;
    } on DioException {
      return false;
    }
  }

  Future<void> removeFavoriteById(int userId, int menuItemId) async {
    await removeFavorite(userId, menuItemId);
  }
}
