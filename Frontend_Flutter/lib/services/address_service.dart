import 'package:dio/dio.dart';
import '../utils/error_utils.dart';
import '../models/address.dart';
import 'dio_client.dart';

class AddressService {
  final Dio _dio = DioClient().dio;

  Future<List<Address>> getAddressesByUser(int userId) async {
    try {
      final response = await _dio.get('/addresses/user/$userId');
      return (response.data as List)
          .map((json) => Address.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<Address> getDefaultAddress(int userId) async {
    try {
      final response = await _dio.get('/addresses/user/$userId/default');
      return Address.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<Address> createAddress({
    required int userId,
    required String fullName,
    required String phoneNumber,
    required String addressLine,
    String? city,
    String? district,
    String? ward,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) async {
    try {
      final response = await _dio.post(
        '/addresses',
        data: {
          'userId': userId,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'addressLine': addressLine,
          'city': city,
          'district': district,
          'ward': ward,
          'latitude': latitude,
          'longitude': longitude,
          'isDefault': isDefault,
        },
      );
      return Address.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<Address> updateAddress(
    int id, {
    String? fullName,
    String? phoneNumber,
    String? addressLine,
    String? city,
    String? district,
    String? ward,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) async {
    try {
      final response = await _dio.put(
        '/addresses/$id',
        data: {
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'addressLine': addressLine,
          'city': city,
          'district': district,
          'ward': ward,
          'latitude': latitude,
          'longitude': longitude,
          'isDefault': isDefault,
        },
      );
      return Address.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<void> setDefaultAddress(int id, int userId) async {
    try {
      await _dio.put(
        '/addresses/$id/default',
        queryParameters: {'userId': userId},
      );
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      await _dio.delete('/addresses/$id');
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }
}
