import 'package:dio/dio.dart';
import '../models/order.dart';
import 'dio_client.dart';

class PaymentService {
  final Dio _dio = DioClient().dio;

  Future<Order> processOrderPayment({
    required int orderId,
    required String paymentMethod,
  }) async {
    try {
      final response = await _dio.post(
        '/orders/$orderId/pay',
        data: {'paymentMethod': paymentMethod},
      );
      return Order.fromJson(response.data);
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
      return 'Loi server: ${e.response?.statusCode}';
    }
    return 'Khong the ket noi den server';
  }
}
