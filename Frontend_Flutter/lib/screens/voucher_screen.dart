import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../providers/voucher_provider.dart';

class VoucherScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voucherState = ref.watch(voucherProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Mã giảm giá'),
      ),
      body: voucherState.isLoading
          ? Center(child: CircularProgressIndicator())
          : voucherState.vouchers.isEmpty
              ? Center(child: Text('Không có mã giảm giá nào'))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: voucherState.vouchers.length,
                  itemBuilder: (context, index) {
                    final voucher = voucherState.vouchers[index];
                    return _VoucherCard(voucher: voucher);
                  },
                ),
    );
  }
}

class _VoucherCard extends StatelessWidget {
  final dynamic voucher;

  const _VoucherCard({required this.voucher});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.local_offer,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voucher.code ?? 'N/A',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _getDiscountText(),
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Đơn tối thiểu: ${voucher.minOrderAmount ?? 0}đ',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDiscountText() {
    if (voucher.discountType == 'PERCENTAGE') {
      return 'Giảm ${voucher.discountValue}%';
    } else {
      return 'Giảm ${voucher.discountValue}đ';
    }
  }
}
