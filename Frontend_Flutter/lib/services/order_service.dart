import 'package:dio/dio.dart';
import '../models/order.dart';
import '../models/checkout_request.dart';
import '../models/payment_request.dart';
import 'dio_client.dart';
import '../utils/token_storage.dart';

class OrderService {
  final Dio _dio = DioClient().dio;

  // Checkout - create order from cart
  Future<Order> checkout() async {
    try {
      final userId = await TokenStorage.getUserId();
      if (userId == null) throw Exception('User not logged in');

      final response = await _dio.post(
        '/orders/checkout',
        queryParameters: {'userId': userId},
      );

      return Order.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get order history for current user
  Future<List<Order>> getOrderHistory() async {
    try {
      final userId = await TokenStorage.getUserId();
      if (userId == null) throw Exception('User not logged in');

      final response = await _dio.get(
        '/orders/my-orders',
        queryParameters: {'userId': userId},
      );

      final List<dynamic> data = response.data;
      return data.map((json) => Order.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get order details
  Future<Order> getOrderDetails(int orderId) async {
    try {
      final response = await _dio.get('/orders/$orderId');
      return Order.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Cancel order
  Future<Order> cancelOrder(int orderId) async {
    try {
      final userId = await TokenStorage.getUserId();
      if (userId == null) throw Exception('User not logged in');

      final response = await _dio.put(
        '/orders/$orderId/cancel',
        queryParameters: {'userId': userId},
      );

      return Order.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Checkout with full details
  Future<Order> checkoutWithDetails(CheckoutRequest request) async {
    try {
      final response = await _dio.post(
        '/orders/checkout',
        data: request.toJson(),
      );
      return Order.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Process payment
  Future<Order> processPayment(int orderId, PaymentRequest request) async {
    try {
      final response = await _dio.post(
        '/orders/$orderId/pay',
        data: request.toJson(),
      );
      return Order.fromJson(response.data);
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
