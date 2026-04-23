import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../services/payment_service.dart';

class PaymentMethodScreen extends ConsumerStatefulWidget {
  final int orderId;
  final double amount;
  final void Function(bool success)? onPaymentComplete;

  const PaymentMethodScreen({
    required this.orderId,
    required this.amount,
    this.onPaymentComplete,
    super.key,
  });

  @override
  ConsumerState<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  final PaymentService _paymentService = PaymentService();
  bool _isProcessing = false;

  Future<void> _pay(BuildContext context, String paymentMethod) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);
    try {
      final order = await _paymentService.processOrderPayment(
        orderId: widget.orderId,
        paymentMethod: paymentMethod,
      );

      if (!context.mounted) return;
      widget.onPaymentComplete?.call(order.paymentStatus == 'PAID');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thanh toan ${order.paymentStatus ?? "PENDING"}'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Loi: $e')));
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _handleCOD(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xac nhan thanh toan COD'),
        content: Text(
          'Ban se thanh toan ${widget.amount.toStringAsFixed(0)}d khi nhan hang.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _pay(context, 'COD');
            },
            child: const Text('Xac nhan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Phuong thuc thanh toan'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _OrderSummary(amount: widget.amount),
                const SizedBox(height: 20),
                _PaymentMethodCard(
                  icon: Icons.account_balance,
                  title: 'Thanh toan qua VNPay',
                  description: 'Gui yeu cau thanh toan len backend',
                  color: Colors.blue,
                  enabled: !_isProcessing,
                  onTap: () => _pay(context, 'VNPAY'),
                ),
                _PaymentMethodCard(
                  icon: Icons.phone_android,
                  title: 'Thanh toan qua Momo',
                  description: 'Gui yeu cau thanh toan len backend',
                  color: Colors.pink,
                  enabled: !_isProcessing,
                  onTap: () => _pay(context, 'MOMO'),
                ),
                _PaymentMethodCard(
                  icon: Icons.money,
                  title: 'Thanh toan khi nhan hang (COD)',
                  description: 'Xac nhan thanh toan sau khi nhan hang',
                  color: Colors.green,
                  enabled: !_isProcessing,
                  onTap: () => _handleCOD(context),
                ),
                _PaymentMethodCard(
                  icon: Icons.credit_card,
                  title: 'Thanh toan bang the',
                  description: 'Gui yeu cau thanh toan len backend',
                  color: Colors.amber,
                  enabled: !_isProcessing,
                  onTap: () => _pay(context, 'CARD'),
                ),
              ],
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withAlpha(38),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final double amount;

  const _OrderSummary({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tong thanh toan',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            '${amount.toStringAsFixed(0)}d',
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
  final bool enabled;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
