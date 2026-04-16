import 'package:dio/dio.dart';
import '../models/category.dart';
import 'dio_client.dart';

class CategoryService {
  final Dio _dio = DioClient().dio;

  // Get all categories
  Future<List<Category>> getAllCategories() async {
    try {
      final response = await _dio.get('/categories');
      final List<dynamic> data = response.data;
      return data.map((json) => Category.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get category by ID
  Future<Category> getCategoryById(int id) async {
    try {
      final response = await _dio.get('/categories/$id');
      return Category.fromJson(response.data);
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
