import 'package:dio/dio.dart';
import '../utils/error_utils.dart';
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
      final userId = await TokenStorage.requireUserId();

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
      throw ErrorUtils.message(e);
    }
  }

  // Update cart item quantity
  Future<Cart> updateQuantity({
    required int menuItemId,
    required int quantity,
  }) async {
    try {
      final userId = await TokenStorage.requireUserId();

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
      throw ErrorUtils.message(e);
    }
  }

  // Get cart
  Future<Cart?> getCart() async {
    try {
      final userId = await TokenStorage.requireUserId();

      final response = await _dio.get(
        '/cart',
        queryParameters: {'userId': userId},
      );

      return Cart.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; // Cart empty/not found
      }
      throw ErrorUtils.message(e);
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      final userId = await TokenStorage.requireUserId();

      await _dio.delete('/cart/clear', queryParameters: {'userId': userId});
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }
}
