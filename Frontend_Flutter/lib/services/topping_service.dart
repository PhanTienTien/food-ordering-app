import 'package:dio/dio.dart';
import '../utils/error_utils.dart';
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
      throw ErrorUtils.message(e);
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
      throw ErrorUtils.message(e);
    }
  }
}
