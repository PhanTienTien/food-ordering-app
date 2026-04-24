import 'package:dio/dio.dart';
import '../utils/error_utils.dart';
import '../models/notification_item.dart';
import 'dio_client.dart';

class NotificationService {
  final Dio _dio = DioClient().dio;

  Future<List<AppNotification>> getNotificationsByUser(int userId) async {
    try {
      final response = await _dio.get('/notifications/user/$userId');
      final List<dynamic> data = response.data;
      return data.map((json) => AppNotification.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<List<AppNotification>> getUnreadNotifications(int userId) async {
    try {
      final response = await _dio.get('/notifications/user/$userId/unread');
      final List<dynamic> data = response.data;
      return data.map((json) => AppNotification.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<int> getUnreadCount(int userId) async {
    try {
      final response = await _dio.get(
        '/notifications/user/$userId/unread-count',
      );
      return (response.data as num).toInt();
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<AppNotification> markAsRead(int id, int userId) async {
    try {
      final response = await _dio.put(
        '/notifications/$id/read',
        queryParameters: {'userId': userId},
      );
      return AppNotification.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<void> markAllAsRead(int userId) async {
    try {
      await _dio.put('/notifications/user/$userId/read-all');
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      await _dio.delete('/notifications/$id');
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }
}
