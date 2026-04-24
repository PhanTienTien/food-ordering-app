import 'package:dio/dio.dart';
import '../utils/error_utils.dart';
import '../models/order.dart';
import '../models/checkout_request.dart';
import 'dio_client.dart';
import '../utils/token_storage.dart';

class OrderService {
  final Dio _dio = DioClient().dio;

  // Checkout - create order from cart
  Future<Order> checkout([CheckoutRequest? request]) async {
    try {
      if (request != null) {
        return checkoutWithDetails(request);
      }

      final userId = await TokenStorage.requireUserId();

      final response = await _dio.post(
        '/orders/checkout',
        queryParameters: {'userId': userId},
      );

      return Order.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  // Get order history for current user
  Future<List<Order>> getOrderHistory() async {
    try {
      final userId = await TokenStorage.requireUserId();

      final response = await _dio.get(
        '/orders/my-orders',
        queryParameters: {'userId': userId},
      );

      final List<dynamic> data = response.data;
      return data.map((json) => Order.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  // Get order details
  Future<Order> getOrderDetails(int orderId) async {
    try {
      final response = await _dio.get('/orders/$orderId');
      return Order.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  // Cancel order
  Future<Order> cancelOrder(int orderId) async {
    try {
      final userId = await TokenStorage.requireUserId();

      final response = await _dio.put(
        '/orders/$orderId/cancel',
        queryParameters: {'userId': userId},
      );

      return Order.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
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
      throw ErrorUtils.message(e);
    }
  }

  // Process payment
  Future<Order> processPayment(int orderId, String paymentMethod) async {
    try {
      final response = await _dio.post(
        '/orders/$orderId/pay',
        data: {'paymentMethod': paymentMethod},
      );
      return Order.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }
}
