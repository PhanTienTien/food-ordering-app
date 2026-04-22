import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../services/payment_service.dart';

class PaymentResultScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> queryParams;
  final String paymentMethod;

  const PaymentResultScreen({
    required this.queryParams,
    required this.paymentMethod,
    super.key,
  });

  @override
  ConsumerState<PaymentResultScreen> createState() => _PaymentResultScreenState();
}

class _PaymentResultScreenState extends ConsumerState<PaymentResultScreen> {
  final PaymentService _paymentService = PaymentService();
  bool isVerifying = true;
  bool? paymentSuccess;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _verifyPayment();
  }

  Future<void> _verifyPayment() async {
    try {
      final success = await _paymentService.verifyPayment(
        widget.paymentMethod,
        widget.queryParams,
      );
      setState(() {
        paymentSuccess = success;
        isVerifying = false;
      });
    } catch (e) {
      setState(() {
        paymentSuccess = false;
        errorMessage = e.toString();
        isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: isVerifying
                ? _LoadingView()
                : paymentSuccess == true
                    ? _SuccessView()
                    : _FailureView(),
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 24),
        Text(
          'Đang xác nhận thanh toán...',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            size: 80,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 32),
        Text(
          'Thanh toán thành công!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Đơn hàng của bạn đã được xác nhận',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(height: 48),
        ElevatedButton(
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          child: Text('Về trang chủ'),
        ),
      ],
    );
  }
}

class _FailureView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.cancel,
            size: 80,
            color: Colors.red,
          ),
        ),
        SizedBox(height: 32),
        Text(
          'Thanh toán thất bại',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Có lỗi xảy ra trong quá trình thanh toán',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(height: 8),
        if (errorMessage != null)
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.red),
          ),
        SizedBox(height: 48),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Thử lại'),
        ),
      ],
    );
  }
}
