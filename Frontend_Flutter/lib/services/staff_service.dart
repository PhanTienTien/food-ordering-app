import 'package:dio/dio.dart';
import '../models/order.dart';
import '../models/menu_item.dart';
import 'dio_client.dart';

class StaffService {
  final Dio _dio = DioClient().dio;

  // Get orders for staff's restaurant
  Future<List<Order>> getRestaurantOrders(int restaurantId) async {
    try {
      final response = await _dio.get('/staff/orders/restaurant/$restaurantId');
      final List<dynamic> data = response.data;
      return data.map((json) => Order.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get orders by status
  Future<List<Order>> getOrdersByStatus(int restaurantId, String status) async {
    try {
      final response = await _dio.get(
        '/staff/orders/restaurant/$restaurantId/status/$status',
      );
      final List<dynamic> data = response.data;
      return data.map((json) => Order.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Accept order
  Future<Order> acceptOrder(int orderId, int staffId) async {
    try {
      final response = await _dio.put(
        '/staff/orders/$orderId/accept',
        queryParameters: {'staffId': staffId},
      );
      return Order.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Reject order
  Future<Order> rejectOrder(int orderId, int staffId) async {
    try {
      final response = await _dio.put(
        '/staff/orders/$orderId/reject',
        queryParameters: {'staffId': staffId},
      );
      return Order.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Mark preparing
  Future<Order> markPreparing(int orderId, int staffId) async {
    try {
      final response = await _dio.put(
        '/staff/orders/$orderId/preparing',
        queryParameters: {'staffId': staffId},
      );
      return Order.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Mark ready
  Future<Order> markReady(int orderId, int staffId) async {
    try {
      final response = await _dio.put(
        '/staff/orders/$orderId/ready',
        queryParameters: {'staffId': staffId},
      );
      return Order.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Mark delivered
  Future<Order> markDelivered(int orderId, int staffId) async {
    try {
      final response = await _dio.put(
        '/staff/orders/$orderId/delivered',
        queryParameters: {'staffId': staffId},
      );
      return Order.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Cancel order
  Future<Order> cancelOrder(int orderId, int staffId, String reason) async {
    try {
      final response = await _dio.put(
        '/staff/orders/$orderId/cancel',
        queryParameters: {'staffId': staffId, 'reason': reason},
      );
      return Order.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get restaurant menu items
  Future<List<MenuItem>> getRestaurantMenuItems(int restaurantId) async {
    try {
      final response = await _dio.get('/staff/menu-items/restaurant/$restaurantId');
      final List<dynamic> data = response.data;
      return data.map((json) => MenuItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Toggle item status
  Future<MenuItem> toggleItemStatus(int itemId, String status) async {
    try {
      final response = await _dio.put(
        '/staff/menu-items/$itemId/toggle-status',
        queryParameters: {'status': status},
      );
      return MenuItem.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Toggle restaurant open/close
  Future<Map<String, dynamic>> toggleRestaurantStatus(int restaurantId) async {
    try {
      final response = await _dio.put(
        '/staff/restaurant/$restaurantId/toggle-open',
      );
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
