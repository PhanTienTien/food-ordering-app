import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dio_client.dart';

class PaymentService {
  final Dio _dio = DioClient().dio;

  // VNPay Payment
  Future<String> createVNPayPayment({
    required double amount,
    required String orderInfo,
    required String returnUrl,
  }) async {
    try {
      final response = await _dio.post('/api/payment/vnpay/create', data: {
        'amount': amount,
        'orderInfo': orderInfo,
        'returnUrl': returnUrl,
      });
      return response.data['paymentUrl'] as String;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Momo Payment
  Future<String> createMomoPayment({
    required double amount,
    required String orderInfo,
    required String returnUrl,
  }) async {
    try {
      final response = await _dio.post('/api/payment/momo/create', data: {
        'amount': amount,
        'orderInfo': orderInfo,
        'returnUrl': returnUrl,
      });
      return response.data['paymentUrl'] as String;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Verify Payment
  Future<bool> verifyPayment(String paymentMethod, Map<String, dynamic> params) async {
    try {
      final response = await _dio.post(
        '/api/payment/$paymentMethod/verify',
        data: params,
      );
      return response.data['success'] as bool;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Launch Payment URL
  Future<void> launchPaymentUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Không thể mở URL thanh toán');
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
