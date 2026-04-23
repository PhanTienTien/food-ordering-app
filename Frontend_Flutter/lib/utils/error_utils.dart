import 'package:dio/dio.dart';

class ErrorUtils {
  static String message(Object error) {
    if (error is String) {
      return error;
    }

    if (error is FormatException) {
      return error.message;
    }

    if (error is DioException) {
      final response = error.response;
      final data = response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Request timed out';
        case DioExceptionType.connectionError:
          return 'Cannot connect to server';
        case DioExceptionType.badResponse:
          return 'Server error: ${response?.statusCode ?? 'unknown'}';
        default:
          return error.message ?? 'Unexpected network error';
      }
    }

    return error.toString();
  }
}
