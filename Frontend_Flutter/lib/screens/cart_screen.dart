// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../models/checkout_request.dart';
import '../models/cart_item.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../screens/payment_method_screen.dart';
import '../widgets/app_header.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).loadCart();
    });
  }

  Future<void> _refreshCart() async {
    await ref.read(cartProvider.notifier).loadCart();
  }

  Future<void> _showCheckoutDialog() async {
    final cart = ref.read(cartProvider).cart;
    final userId = ref.read(authProvider).userId;
    if (cart == null || cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Giỏ hàng đang trống')));
      return;
    }
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy user hiện tại')),
      );
      return;
    }

    final formKey = GlobalKey<FormState>();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    final noteController = TextEditingController();
    final voucherController = TextEditingController();
    String selectedPaymentMethod = 'COD';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Thanh toán đơn hàng'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ giao hàng',
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Bắt buộc' : null,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Số điện thoại'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Bắt buộc' : null,
                ),
                TextFormField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Ghi chú'),
                ),
                TextFormField(
                  controller: voucherController,
                  decoration: const InputDecoration(labelText: 'Mã giảm giá'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedPaymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'Phương thức thanh toán',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'COD', child: Text('COD')),
                    DropdownMenuItem(value: 'VNPAY', child: Text('VNPay')),
                    DropdownMenuItem(value: 'MOMO', child: Text('Momo')),
                    DropdownMenuItem(value: 'CARD', child: Text('Card')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      selectedPaymentMethod = value;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final request = CheckoutRequest(
      userId: userId,
      shippingAddress: addressController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      note: noteController.text.trim().isEmpty
          ? null
          : noteController.text.trim(),
      paymentMethod: selectedPaymentMethod,
      voucherCode: voucherController.text.trim().isEmpty
          ? null
          : voucherController.text.trim(),
    );

    final success = await ref
        .read(orderActionProvider.notifier)
        .checkout(request);
    if (!context.mounted) return;
    if (!success) {
      final error = ref.read(orderActionProvider).error;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error ?? 'Checkout thất bại')));
      return;
    }

    final order = ref.read(orderActionProvider).currentOrder;
    if (order == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không lấy được đơn hàng vừa tạo')),
      );
      return;
    }

    final amount = order.finalPrice ?? order.totalPrice ?? 0.0;
    if (selectedPaymentMethod == 'COD') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã tạo đơn COD thành công')),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentMethodScreen(orderId: order.id!, amount: amount),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(title: 'Cart', showBack: true),
      body: RefreshIndicator(
        onRefresh: _refreshCart,
        child: cartState.isLoading
            ? ListView(
                children: [
                  SizedBox(height: 300),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : cartState.cart == null || cartState.cart!.items.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 220),
                  Center(child: Text('Giỏ hàng đang trống')),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...cartState.cart!.items.map(
                    (item) => _CartItemTile(
                      item: item,
                      onIncrease: () => ref
                          .read(cartProvider.notifier)
                          .updateQuantity(
                            item.menuItem?.id ?? 0,
                            item.quantity + 1,
                          ),
                      onDecrease: () {
                        if (item.quantity > 1) {
                          ref
                              .read(cartProvider.notifier)
                              .updateQuantity(
                                item.menuItem?.id ?? 0,
                                item.quantity - 1,
                              );
                        } else {
                          ref
                              .read(cartProvider.notifier)
                              .removeItem(item.menuItem?.id ?? 0);
                        }
                      },
                      onDelete: () => ref
                          .read(cartProvider.notifier)
                          .removeItem(item.menuItem?.id ?? 0),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Summary(
                    totalAmount: cartState.totalAmount,
                    itemCount: cartState.itemCount,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showCheckoutDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Checkout'),
                  ),
                ],
              ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onDelete;

  const _CartItemTile({
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final menuItem = item.menuItem;
    final image = menuItem?.image ?? 'https://via.placeholder.com/100';
    final name = menuItem?.name ?? 'Không tên';
    final price = item.totalPrice ?? ((item.unitPrice ?? 0) * item.quantity);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              image,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 72,
                height: 72,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${price.toStringAsFixed(0)} đ'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: onDecrease,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(item.quantity.toString()),
                    IconButton(
                      onPressed: onIncrease,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final double totalAmount;
  final int itemCount;

  const _Summary({required this.totalAmount, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _row('Số món', itemCount.toString()),
          const SizedBox(height: 8),
          _row('Tổng tiền', '${totalAmount.toStringAsFixed(0)} đ'),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
