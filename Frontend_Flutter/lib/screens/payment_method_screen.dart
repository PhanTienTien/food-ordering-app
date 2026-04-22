import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../services/payment_service.dart';

class PaymentMethodScreen extends ConsumerWidget {
  final double amount;
  final String orderId;
  final Function(bool) onPaymentComplete;

  const PaymentMethodScreen({
    required this.amount,
    required this.orderId,
    required this.onPaymentComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentService = PaymentService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Phương thức thanh toán'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _OrderSummary(amount: amount),
            SizedBox(height: 20),
            _PaymentMethodCard(
              icon: Icons.account_balance,
              title: 'Thanh toán qua VNPay',
              description: 'Thanh toán an toàn với VNPay',
              color: Colors.blue,
              onTap: () => _handleVNPay(context, paymentService),
            ),
            _PaymentMethodCard(
              icon: Icons.phone_android,
              title: 'Thanh toán qua Momo',
              description: 'Thanh toán nhanh với ví Momo',
              color: Colors.pink,
              onTap: () => _handleMomo(context, paymentService),
            ),
            _PaymentMethodCard(
              icon: Icons.money,
              title: 'Thanh toán khi nhận hàng (COD)',
              description: 'Tiền mặt khi nhận hàng',
              color: Colors.green,
              onTap: () => _handleCOD(context),
            ),
            _PaymentMethodCard(
              icon: Icons.credit_card,
              title: 'Thanh toán bằng ví',
              description: 'Sử dụng điểm tích lũy',
              color: Colors.amber,
              onTap: () => _handleWallet(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleVNPay(BuildContext context, PaymentService paymentService) async {
    try {
      final paymentUrl = await paymentService.createVNPayPayment(
        amount: amount,
        orderInfo: 'Thanh toán đơn hàng $orderId',
        returnUrl: 'foodapp://payment-return',
      );
      await paymentService.launchPaymentUrl(paymentUrl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  Future<void> _handleMomo(BuildContext context, PaymentService paymentService) async {
    try {
      final paymentUrl = await paymentService.createMomoPayment(
        amount: amount,
        orderInfo: 'Thanh toán đơn hàng $orderId',
        returnUrl: 'foodapp://payment-return',
      );
      await paymentService.launchPaymentUrl(paymentUrl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  void _handleCOD(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận thanh toán COD'),
        content: Text('Bạn sẽ thanh toán ${amount.toStringAsFixed(0)}đ khi nhận hàng.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onPaymentComplete(true);
            },
            child: Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  void _handleWallet(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tính năng thanh toán ví đang phát triển')),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final double amount;

  const _OrderSummary({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng thanh toán',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            '${amount.toStringAsFixed(0)}đ',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
