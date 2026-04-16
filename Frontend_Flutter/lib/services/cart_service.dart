import 'package:dio/dio.dart';
import '../models/cart.dart';
import 'dio_client.dart';
import '../utils/token_storage.dart';

class CartService {
  final Dio _dio = DioClient().dio;

  // Add item to cart
  Future<Cart> addToCart({
    required int menuItemId,
    required int quantity,
  }) async {
    try {
      final userId = await TokenStorage.getUserId();
      if (userId == null) throw Exception('User not logged in');

      final response = await _dio.post(
        '/cart/add',
        queryParameters: {
          'userId': userId,
          'menuItemId': menuItemId,
          'quantity': quantity,
        },
      );

      return Cart.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Update cart item quantity
  Future<Cart> updateQuantity({
    required int menuItemId,
    required int quantity,
  }) async {
    try {
      final userId = await TokenStorage.getUserId();
      if (userId == null) throw Exception('User not logged in');

      final response = await _dio.put(
        '/cart/update',
        queryParameters: {
          'userId': userId,
          'menuItemId': menuItemId,
          'quantity': quantity,
        },
      );

      return Cart.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get cart
  Future<Cart?> getCart() async {
    try {
      final userId = await TokenStorage.getUserId();
      if (userId == null) throw Exception('User not logged in');

      final response = await _dio.get(
        '/cart',
        queryParameters: {'userId': userId},
      );

      return Cart.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; // Cart empty/not found
      }
      throw _handleError(e);
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      final userId = await TokenStorage.getUserId();
      if (userId == null) throw Exception('User not logged in');

      await _dio.delete(
        '/cart/clear',
        queryParameters: {'userId': userId},
      );
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
