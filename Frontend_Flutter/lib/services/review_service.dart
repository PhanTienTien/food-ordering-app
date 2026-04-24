import 'package:dio/dio.dart';
import '../utils/error_utils.dart';
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
      throw ErrorUtils.message(e);
    }
  }

  Future<List<Review>> getReviewsByRestaurant(int restaurantId) async {
    try {
      final response = await _dio.get('/reviews/restaurant/$restaurantId');
      return (response.data as List)
          .map((json) => Review.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<double> getAverageRating(int menuItemId) async {
    try {
      final response = await _dio.get(
        '/reviews/menu-item/$menuItemId/average-rating',
      );
      final value = response.data;
      if (value is num) {
        return value.toDouble();
      }
      throw const FormatException('Invalid average rating response');
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
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
      throw ErrorUtils.message(e);
    }
  }
}
