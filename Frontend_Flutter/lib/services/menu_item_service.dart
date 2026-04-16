import 'package:dio/dio.dart';
import '../models/menu_item.dart';
import 'dio_client.dart';

class MenuItemService {
  final Dio _dio = DioClient().dio;

  // Get all menu items
  Future<List<MenuItem>> getAllMenuItems() async {
    try {
      final response = await _dio.get('/menu-items');
      final List<dynamic> data = response.data;
      return data.map((json) => MenuItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get menu items by restaurant
  Future<List<MenuItem>> getMenuItemsByRestaurant(int restaurantId) async {
    try {
      final response = await _dio.get('/menu-items/restaurant/$restaurantId');
      final List<dynamic> data = response.data;
      return data.map((json) => MenuItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get menu items by category
  Future<List<MenuItem>> getMenuItemsByCategory(int categoryId) async {
    try {
      final response = await _dio.get('/menu-items/category/$categoryId');
      final List<dynamic> data = response.data;
      return data.map((json) => MenuItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Search menu items
  Future<List<MenuItem>> searchMenuItems(String keyword) async {
    try {
      final response = await _dio.get(
        '/menu-items/search',
        queryParameters: {'keyword': keyword},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => MenuItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Filter menu items
  Future<List<MenuItem>> filterMenuItems({
    String? keyword,
    int? restaurantId,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (keyword != null) queryParams['keyword'] = keyword;
      if (restaurantId != null) queryParams['restaurantId'] = restaurantId;
      if (categoryId != null) queryParams['categoryId'] = categoryId;
      if (minPrice != null) queryParams['minPrice'] = minPrice;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice;

      final response = await _dio.get(
        '/menu-items/filter',
        queryParameters: queryParams,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => MenuItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get available menu items only
  Future<List<MenuItem>> getAvailableMenuItems() async {
    try {
      final response = await _dio.get('/menu-items/available');
      final List<dynamic> data = response.data;
      return data.map((json) => MenuItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get menu item details
  Future<MenuItem> getMenuItemById(int id) async {
    try {
      final response = await _dio.get('/menu-items/$id');
      return MenuItem.fromJson(response.data);
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
