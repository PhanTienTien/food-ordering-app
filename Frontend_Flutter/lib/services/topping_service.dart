import 'package:dio/dio.dart';
import '../models/topping.dart';
import 'dio_client.dart';

class ToppingService {
  final Dio _dio = DioClient().dio;

  Future<List<Topping>> getToppingsByRestaurant(int restaurantId) async {
    try {
      final response = await _dio.get('/toppings/restaurant/$restaurantId');
      return (response.data as List)
          .map((json) => Topping.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Topping>> getAvailableToppingsByRestaurant(
    int restaurantId,
  ) async {
    try {
      final response = await _dio.get(
        '/toppings/restaurant/$restaurantId/available',
      );
      return (response.data as List)
          .map((json) => Topping.fromJson(json))
          .toList();
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
