import 'package:dio/dio.dart';
import '../models/review.dart';
import 'dio_client.dart';

class ReviewService {
  final Dio _dio = DioClient().dio;

  Future<List<Review>> getReviewsByMenuItem(int menuItemId) async {
    try {
      final response = await _dio.get('/reviews/menu-item/$menuItemId');
      return (response.data as List)
          .map((json) => Review.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Review>> getReviewsByRestaurant(int restaurantId) async {
    try {
      final response = await _dio.get('/reviews/restaurant/$restaurantId');
      return (response.data as List)
          .map((json) => Review.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<double> getAverageRating(int menuItemId) async {
    try {
      final response = await _dio.get(
        '/reviews/menu-item/$menuItemId/average-rating',
      );
      return response.data as double;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Review> createReview(
    int userId,
    int orderId,
    int rating,
    String comment,
  ) async {
    try {
      final response = await _dio.post(
        '/reviews',
        data: {
          'userId': userId,
          'orderId': orderId,
          'rating': rating,
          'comment': comment,
        },
      );
      return Review.fromJson(response.data);
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
