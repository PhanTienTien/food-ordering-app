import 'package:dio/dio.dart';
import '../models/restaurant.dart';
import 'dio_client.dart';

class RestaurantService {
  final Dio _dio = DioClient().dio;

  // Get all restaurants
  Future<List<Restaurant>> getAllRestaurants() async {
    try {
      final response = await _dio.get('/restaurants');
      final List<dynamic> data = response.data;
      return data.map((json) => Restaurant.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get open restaurants
  Future<List<Restaurant>> getOpenRestaurants() async {
    try {
      final response = await _dio.get('/restaurants/open');
      final List<dynamic> data = response.data;
      return data.map((json) => Restaurant.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get nearby restaurants with distance
  Future<List<Map<String, dynamic>>> getNearbyRestaurants({
    required double userLat,
    required double userLon,
    double radiusKm = 10.0,
  }) async {
    try {
      final response = await _dio.get(
        '/restaurants/nearby',
        queryParameters: {
          'userLat': userLat,
          'userLon': userLon,
          'radiusKm': radiusKm,
        },
      );
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Calculate shipping fee
  Future<double> calculateShippingFee({
    required int restaurantId,
    required double userLat,
    required double userLon,
  }) async {
    try {
      final response = await _dio.get(
        '/restaurants/$restaurantId/shipping-fee',
        queryParameters: {'userLat': userLat, 'userLon': userLon},
      );
      return response.data as double;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get restaurant by ID
  Future<Restaurant> getRestaurantById(int id) async {
    try {
      final response = await _dio.get('/restaurants/$id');
      return Restaurant.fromJson(response.data);
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
