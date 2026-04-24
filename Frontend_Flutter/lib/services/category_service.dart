import 'package:dio/dio.dart';
import '../utils/error_utils.dart';
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
      throw ErrorUtils.message(e);
    }
  }

  // Get category by ID
  Future<Category> getCategoryById(int id) async {
    try {
      final response = await _dio.get('/categories/$id');
      return Category.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }
}
