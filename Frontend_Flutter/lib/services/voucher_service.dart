import 'package:dio/dio.dart';
import '../utils/error_utils.dart';
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
      throw ErrorUtils.message(e);
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
      throw ErrorUtils.message(e);
    }
  }

  Future<double> validateVoucher(String code, double orderAmount) async {
    try {
      final response = await _dio.post(
        '/vouchers/validate',
        queryParameters: {'code': code, 'orderAmount': orderAmount},
      );
      final value = response.data;
      if (value is num) {
        return value.toDouble();
      }
      throw const FormatException('Invalid voucher value response');
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }
}
