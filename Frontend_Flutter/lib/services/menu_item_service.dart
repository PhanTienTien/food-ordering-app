import 'package:dio/dio.dart';
import '../utils/error_utils.dart';
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
      throw ErrorUtils.message(e);
    }
  }

  // Get menu items by restaurant
  Future<List<MenuItem>> getMenuItemsByRestaurant(int restaurantId) async {
    try {
      final response = await _dio.get('/menu-items/restaurant/$restaurantId');
      final List<dynamic> data = response.data;
      return data.map((json) => MenuItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  // Get menu items by category
  Future<List<MenuItem>> getMenuItemsByCategory(int categoryId) async {
    try {
      final response = await _dio.get('/menu-items/category/$categoryId');
      final List<dynamic> data = response.data;
      return data.map((json) => MenuItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
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
      throw ErrorUtils.message(e);
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
      throw ErrorUtils.message(e);
    }
  }

  // Get available menu items only
  Future<List<MenuItem>> getAvailableMenuItems() async {
    try {
      final response = await _dio.get('/menu-items/available');
      final List<dynamic> data = response.data;
      return data.map((json) => MenuItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  // Get menu item details
  Future<MenuItem> getMenuItemById(int id) async {
    try {
      final response = await _dio.get('/menu-items/$id');
      return MenuItem.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }
}
