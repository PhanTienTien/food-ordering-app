import 'package:dio/dio.dart';
import '../models/voucher.dart';
import 'dio_client.dart';

class VoucherService {
  final Dio _dio = DioClient().dio;

  Future<List<Voucher>> getActiveVouchers() async {
    try {
      final response = await _dio.get('/vouchers/active');
      return (response.data as List)
          .map((json) => Voucher.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Voucher?> getVoucherByCode(String code) async {
    try {
      final response = await _dio.get('/vouchers/code/$code');
      return Voucher.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw _handleError(e);
    }
  }

  Future<double> validateVoucher(String code, double orderAmount) async {
    try {
      final response = await _dio.post(
        '/vouchers/validate',
        queryParameters: {'code': code, 'orderAmount': orderAmount},
      );
      return response.data as double;
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
