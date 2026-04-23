import 'package:dio/dio.dart';
import '../models/user.dart';
import '../models/restaurant.dart';
import '../models/category.dart';
import 'dio_client.dart';

class AdminService {
  final Dio _dio = DioClient().dio;

  // ==================== RESTAURANT MANAGEMENT ====================

  // Get all restaurants
  Future<List<Restaurant>> getAllRestaurants() async {
    try {
      final response = await _dio.get('/admin/restaurants');
      final List<dynamic> data = response.data;
      return data.map((json) => Restaurant.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get pending restaurants
  Future<List<Restaurant>> getPendingRestaurants() async {
    try {
      final response = await _dio.get('/admin/restaurants/pending');
      final List<dynamic> data = response.data;
      return data.map((json) => Restaurant.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Approve restaurant
  Future<Restaurant> approveRestaurant(int id) async {
    try {
      final response = await _dio.put('/admin/restaurants/$id/approve');
      return Restaurant.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Reject restaurant
  Future<Restaurant> rejectRestaurant(int id) async {
    try {
      final response = await _dio.put('/admin/restaurants/$id/reject');
      return Restaurant.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Lock restaurant
  Future<Restaurant> lockRestaurant(int id) async {
    try {
      final response = await _dio.put('/admin/restaurants/$id/lock');
      return Restaurant.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Unlock restaurant
  Future<Restaurant> unlockRestaurant(int id) async {
    try {
      final response = await _dio.put('/admin/restaurants/$id/unlock');
      return Restaurant.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Delete restaurant
  Future<void> deleteRestaurant(int id) async {
    try {
      await _dio.delete('/admin/restaurants/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== USER MANAGEMENT ====================

  // Get all users
  Future<List<User>> getAllUsers() async {
    try {
      final response = await _dio.get('/admin/users');
      final List<dynamic> data = response.data;
      return data.map((json) => User.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get users by role
  Future<List<User>> getUsersByRole(String role) async {
    try {
      final response = await _dio.get('/admin/users/role/$role');
      final List<dynamic> data = response.data;
      return data.map((json) => User.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Lock user
  Future<User> lockUser(int id) async {
    try {
      final response = await _dio.put('/admin/users/$id/lock');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Unlock user
  Future<User> unlockUser(int id) async {
    try {
      final response = await _dio.put('/admin/users/$id/unlock');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Delete user
  Future<void> deleteUser(int id) async {
    try {
      await _dio.delete('/admin/users/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> createStaffUser({
    required String name,
    required String email,
    required String password,
    required int restaurantId,
  }) async {
    try {
      final response = await _dio.post(
        '/admin/users/staff',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'restaurantId': restaurantId,
        },
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== CATEGORY MANAGEMENT ====================

  // Get all categories
  Future<List<Category>> getAllCategories() async {
    try {
      final response = await _dio.get('/admin/categories');
      final List<dynamic> data = response.data;
      return data.map((json) => Category.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Create category
  Future<Category> createCategory(String name) async {
    try {
      final response = await _dio.post(
        '/admin/categories',
        data: {'name': name},
      );
      return Category.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Update category
  Future<Category> updateCategory(int id, String name) async {
    try {
      final response = await _dio.put(
        '/admin/categories/$id',
        data: {'name': name},
      );
      return Category.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Delete category
  Future<void> deleteCategory(int id) async {
    try {
      await _dio.delete('/admin/categories/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== REPORTS ====================

  // Get dashboard summary
  Future<Map<String, dynamic>> getDashboardSummary() async {
    try {
      final response = await _dio.get('/admin/reports/dashboard');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get revenue report
  Future<Map<String, dynamic>> getRevenueReport(
    String startDate,
    String endDate,
  ) async {
    try {
      final response = await _dio.get(
        '/admin/reports/revenue',
        queryParameters: {'startDate': startDate, 'endDate': endDate},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get top restaurants
  Future<List<dynamic>> getTopRestaurants({int limit = 10}) async {
    try {
      final response = await _dio.get(
        '/admin/reports/top-restaurants',
        queryParameters: {'limit': limit},
      );
      return response.data as List;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get order statistics
  Future<Map<String, dynamic>> getOrderStats() async {
    try {
      final response = await _dio.get('/admin/reports/order-stats');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
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
