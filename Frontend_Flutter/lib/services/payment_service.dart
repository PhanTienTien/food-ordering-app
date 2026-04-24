import 'package:dio/dio.dart';
import '../utils/error_utils.dart';
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
      throw ErrorUtils.message(e);
    }
  }
}
